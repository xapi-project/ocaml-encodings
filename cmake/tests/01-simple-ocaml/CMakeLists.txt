# Test case for the CMake/OCaml project

# Descriptions: testcase creating the most simple of libraries, with an
# install target

cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../.. )

project( 01-simple-ocaml NONE )

find_package( OCaml REQUIRED )
include( UseOCaml )

add_ocaml_library( foolib
    SOURCES foo
    )

install_ocaml_package( foo
    LIBRARIES foolib
    METAFILE foolib.meta
    )
