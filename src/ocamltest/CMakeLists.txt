add_custom_command( OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/ocamltest_META"
    COMMAND sed
        "s,@VERSION@,${ocaml-libs_VERSION_MAJOR}.${ocaml-libs_VERSION_MINOR},g"
        < "${CMAKE_CURRENT_SOURCE_DIR}/META.in" > "${CMAKE_CURRENT_BINARY_DIR}/ocamltest_META"
    MAIN_DEPENDENCY "${CMAKE_CURRENT_SOURCE_DIR}/META.in"
    COMMENT "Building META file for encodings"
    )
add_custom_target( ocamltest.meta ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/ocamltest_META"
    )

add_ocaml_library( ocamltest
    SOURCES ocamltest
    )

install_ocaml_package( ocamltest
    LIBRARIES ocamltest
    METAFILE "${CMAKE_CURRENT_BINARY_DIR}/ocamltest_META"
    )
