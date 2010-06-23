cmake_minimum_required( VERSION 2.6 )
set( CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" )

project( ocaml-libs NONE )
set( ocaml-libs_VERSION_MAJOR 0 )
set( ocaml-libs_VERSION_MINOR 1 )

find_package( OCaml REQUIRED )
include( UseOCaml )

execute_process( COMMAND ocamlfind printconf destdir
    COMMAND sed -e "s,/usr/,,"
    OUTPUT_VARIABLE OCAML_DESTDIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
set( CMAKE_OCAML_PKGINSTALLDIR ${OCAML_DESTDIR} )

# Order with dependencies in mind.
add_subdirectory( src/encodings )
add_subdirectory( src/ocamltest )
add_subdirectory( src/encodings/test )
add_subdirectory( src/ocamltest-examples )
add_subdirectory( src/ocamltest-examples/test )

include( InstallRequiredSystemLibraries )
set( CPACK_PACKAGE_VENDOR "Citrix Systems Ltd." )
set( CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/rpm-extras/License.txt" )
set( CPACK_PACKAGE_DESCRIPTION_SUMMARY "General OCaml tools and extensions." )
set( CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/rpm-extras/Description.txt" )
set( CPACK_PACKAGE_VERSION_MAJOR "${ocaml-libs_VERSION_MAJOR}" )
set( CPACK_PACKAGE_VERSION_MINOR "${ocaml-libs_VERSION_MINOR}" )
set( CPACK_PACKAGE_VERSION_PATCH "0" )
set( CPACK_GENERATOR "RPM" )
set( CPACK_SOURCE_GENERATOR "RPM" )
include( CPack )
