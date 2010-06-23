# Test case for the CMake/OCaml project

# Descriptions: an executable which is a unittest (i.e. it should be run after
# building)

cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../.. )

project( 05-exe-unittest NONE )

find_package( OCaml REQUIRED )
include( UseOCaml )

add_ocaml_executable( foo
	SOURCES foo.ml
        RUN_POST_BUILD
	)

add_ocaml_executable( bar
	SOURCES bar.ml
	)
