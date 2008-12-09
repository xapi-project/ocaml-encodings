BUILD=ocamlbuild -no-links -I source

all: target

build:
	$(BUILD) source/ocamltest/main/ocamltest.cmxa
	$(BUILD) source/ocamltest-examples/test/example_test.native

clean:
	rm -rf target
	ocamlbuild -clean

target: build
	mkdir -p target/{main,test}/{bin,doc,lib}
	ln -sf ../../../_build/source/ocamltest/main/ocamltest.{a,cmi,cmxa}       target/main/lib/
	ln -sf ../../../_build/source/ocamltest-examples/test/example_test.native target/test/bin/

.PHONY: all build clean target
