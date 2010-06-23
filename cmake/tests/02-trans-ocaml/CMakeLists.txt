# Test case for the CMake/OCaml project

# Descriptions: testcase constisting of two libraries, the second depending on
# the first

cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../.. )

project( 02-trans-ocaml NONE )

find_package( OCaml REQUIRED )
include( UseOCaml )

add_ocaml_library( foolib
    SOURCES foo
    )

add_ocaml_library( barlib
    SOURCES bar
    LIBRARIES foolib
    )

install_ocaml_package( foobar
    LIBRARIES foolib barlib
    METAFILE foobar.meta
    )
