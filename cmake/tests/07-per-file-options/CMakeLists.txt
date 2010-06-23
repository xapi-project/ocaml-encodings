# Test case for the CMake/OCaml project

# Descriptions: testcase using a pre-processor for one of the files in an
# executable only

cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../.. )

project( 07-per-file-options NONE )

find_package( OCaml REQUIRED )
include( UseOCaml )

add_ocaml_file_options( foo
    SOURCES foo.ml
    OCAMLCOPTS -pp camlp4r
    )

add_ocaml_executable( foo
    SOURCES foo bar
    )
