encodings
=========
Character and string encoding (UTF) library for OCaml.

Building pre-requisites
-----------------------
encodings requires OMake and ocamlfind to build. You can install both with

    sudo aptitude install omake ocaml-findlib

on Ubuntu. For other operating systems, please refer to the
[OMake homepage](http://omake.metaprl.org/index.html) and
the [Findlib homepage](http://projects.camlcity.org/projects/findlib.html).

The unit tests require the
[OCamlTest library](http://github.com/ocamltest/ocamltest).

Building instructions
---------------------
Run omake in the directory of this README file:

    omake

This will also try to run the unit tests. If the OCamlTest library is missing,
encodings will compile, but compiling and running the unit tests will fail.
Don't panic.

Installation
------------
To use the encodings package in your OCaml projects, install it by running:

    sudo omake install

Un-installing
-------------
To remove the installed encodings OCaml package, run:

    sudo omake uninstall

Documentation
-------------
We apologise for not having written any standalone documentation, yet. Please
refer to the comments within the source code.
