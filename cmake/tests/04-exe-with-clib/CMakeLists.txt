# Test case for the CMake/OCaml project

# Descriptions: an executable with a C library

cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../.. )

project( 04-exe-with-clib NONE )

find_package( OCaml REQUIRED )
include( UseOCaml )

add_ocaml_c_library( cstubs
	SOURCES cstubs1.c cstubs2.c
	)

add_ocaml_library( foo
	SOURCES foo.mli
	LIBRARIES cstubs
	)

add_ocaml_executable( bar
	SOURCES bar.ml
	LIBRARIES foo
	)
