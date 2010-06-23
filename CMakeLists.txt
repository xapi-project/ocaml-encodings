cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" )

project( ocaml-libs NONE )
set( ocaml-libs_VERSION_MAJOR 0 )
set( ocaml-libs_VERSION_MINOR 0 )

find_package( OCaml REQUIRED )
include( UseOCaml )

add_subdirectory( source/encodings/main )
add_subdirectory( source/ocamltest/main )
add_subdirectory( source/ocamltest-examples/main )

add_subdirectory( source/encodings/test )
add_subdirectory( source/ocamltest-examples/test )

include( InstallRequiredSystemLibraries )
set( CPACK_PACKAGE_VENDOR "Citrix Systems Ltd." )
set( CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/rpm-extras/License.txt" )
set( CPACK_PACKAGE_DESCRIPTION_SUMMARY "Testing stuff" )
set( CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/rpm-extras/Description.txt" )
set( CPACK_PACKAGE_VERSION_MAJOR "${ocaml-libs_VERSION_MAJOR}" )
set( CPACK_PACKAGE_VERSION_MINOR "${ocaml-libs_VERSION_MINOR}" )
set( CPACK_PACKAGE_VERSION_PATCH "0" )
set( CPACK_GENERATOR "RPM" )
set( CPACK_SOURCE_GENERATOR "RPM" )
include( CPack )
