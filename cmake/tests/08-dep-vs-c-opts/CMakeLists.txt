# Test case for the CMake/OCaml project

# Descriptions: testcase using a pre-processor

cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../.. )

project( 06-pre-proc NONE )

find_package( OCaml REQUIRED )
include( UseOCaml )

add_ocaml_executable( foo
    SOURCES foo
    OCAMLOPTS -pp camlp4r 
    OCAMLCOPTS -thread
    )
