build_command = ocamlbuild -no-links -I source -Xs _build,target

# Build the given target if (and only if) it requires building.
build = $(build_command) $1

# Build and test the given target if (and only if) it requires building.
build_and_test = $(build_command) -nothing-should-be-rebuilt $1 &>/dev/null || $(build_command) $1 --

.PHONY: all build clean target

all: build

clean:
	rm -rf target
	ocamlbuild -clean

target:
	mkdir -p target/{main,test}/{bin,doc,lib}

build: build-encodings build-ocamltest

build-encodings: target
	$(call build,source/encodings/main/encodings.cmxa)
	$(call build,source/encodings/test/encodings_test.cmxa)
	$(call build_and_test,source/encodings/test/encodings_test.native)
	ln -sf ../../../_build/source/encodings/main/encodings.{a,cmi,cmxa}      target/main/lib/
	ln -sf ../../../_build/source/encodings/test/encodings_test.{a,cmi,cmxa} target/test/lib/
	ln -sf ../../../_build/source/encodings/test/encodings_test.native       target/test/bin/

build-ocamltest: target
	$(call build,source/ocamltest/main/ocamltest.cmxa)
	$(call build,source/ocamltest-examples/test/example_test.native)
	ln -sf ../../../_build/source/ocamltest/main/ocamltest.{a,cmi,cmxa}       target/main/lib/
	ln -sf ../../../_build/source/ocamltest-examples/test/example_test.native target/test/bin/
