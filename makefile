ifdef B_BASE
    include $(B_BASE)/common.mk
else
    MY_OUTPUT_DIR ?= $(CURDIR)/output
    MY_OBJ_DIR ?= $(CURDIR)/obj
    OCAML_BUILD_FLAGS = -X $(DESTDIR)

%/.dirstamp :
	mkdir -p $*
	touch $@

endif

MODULES = encodings ocamltest

VERSION := $(shell hg parents --template "{rev}" 2>/dev/null || echo 0.0)
INSTALLDIR := $(shell ocamlfind printconf destdir)
DESTDIR = $(MY_OBJ_DIR)/output

build_command = ocamlbuild -r -no-links -I source $(OCAML_BUILD_FLAGS) -cflags -g
install_command = mkdir -p $(DESTDIR)$(INSTALLDIR); \
		  ocamlfind install -destdir $(DESTDIR)$(INSTALLDIR)

# Build the given target if (and only if) it requires building.
build = $(build_command) source/$1/main/$(1).cmxa

# Build and test the given target if (and only if) it requires building.
build_and_test = if [ -d source/$1/test ]; then \
		     ($(build_command) -nothing-should-be-rebuilt source/$1/test/$(1)_test.native &>/dev/null || \
		     $(build_command) source/$1/test/$(1)_test.native -- )\
		 fi

# Build the META file needed for install
build_meta = sed 's,@VERSION@,$(VERSION),g' < source/$(1)/main/META.in > _build/source/$(1)/main/META

# Install the given target
install = $(install_command) $(1) _build/source/$(1)/main/META _build/source/$(1)/main/*.{a,cmx}

.PHONY : all clean install

all : $(patsubst %,build-%,$(MODULES))

clean :
	rm -f *~
	ocamlbuild -clean

install : $(patsubst %,install-%,$(MODULES))

.PHONY : install-pre
install-pre : $(MY_OBJ_DIR)/.dirstamp
	rm -rf $(DESTDIR)$(INSTALLDIR)

build-% :
	$(call build,$*)
	$(call build_and_test,$*)

install-% : build-% install-pre
	$(call build_meta,$*)
	$(call install,$*)

# This is the target that the Xen build system calls.  It should build
# everything required for the chroot.
.PHONY : build
build : $(MY_OUTPUT_DIR)/ocaml-the-libs.tar.gz

$(MY_OUTPUT_DIR)/ocaml-the-libs.tar.gz : install $(MY_OUTPUT_DIR)/.dirstamp
	tar -C $(DESTDIR) -c -z -f $@ .
