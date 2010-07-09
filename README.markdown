ocaml-encodings
===============
Character and string encoding (UTF) library for OCaml.

Building pre-requisites
-----------------------
ocaml-encodings requires OMake and ocamlfind to build. You can install both
with

    sudo aptitude install omake ocaml-findlib

on Ubuntu. For other operating systems, please refer to the
[OMake homepage](http://omake.metaprl.org/index.html) and
the [Findlib homepage](http://projects.camlcity.org/projects/findlib.html).

The unit tests require the
[OCamlTest library](http://github.com/xen-org/ocamltest). Note that this
is not required for installation.

Building instructions
---------------------
If you simply want to install this library, please skip to the next section.

To build the library, run omake in the directory of this README file:

    omake

This will also try to run the unit tests. If the OCamlTest library is missing,
ocaml-encodings will compile, but compiling and running the unit tests will
fail.

Installation
------------
To (build and) install the ocaml-encodings library, run:

    sudo omake install

Note that running just this command bypasses the unit tests (which require the
OCamlTest library).

Un-installing
-------------
To remove the installed ocaml-encodings OCaml package, run:

    sudo omake uninstall

Documentation
-------------
We apologise for not having written any standalone documentation, yet. Please
refer to the comments within the source code.
