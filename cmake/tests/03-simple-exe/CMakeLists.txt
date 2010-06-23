# Test case for the CMake/OCaml project

# Descriptions: testcase creating the most simple of executables

cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../.. )

project( 03-simple-exe NONE )

find_package( OCaml REQUIRED )
include( UseOCaml )

add_ocaml_executable( foo
    SOURCES foo
    )
