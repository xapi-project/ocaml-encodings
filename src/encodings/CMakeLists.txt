add_custom_command( OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/encodings_META"
    COMMAND sed
        "s,@VERSION@,${ocaml-libs_VERSION_MAJOR}.${ocaml-libs_VERSION_MINOR},g"
        < "${CMAKE_CURRENT_SOURCE_DIR}/META.in" > "${CMAKE_CURRENT_BINARY_DIR}/encodings_META"
    MAIN_DEPENDENCY "${CMAKE_CURRENT_SOURCE_DIR}/META.in"
    COMMENT "Building META file for encodings"
    )
add_custom_target( encodings.meta ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/encodings_META"
    )

add_ocaml_library( encodings
    SOURCES encodings encodings_private
    )

install_ocaml_package( encodings
    LIBRARIES encodings
    METAFILE "${CMAKE_CURRENT_BINARY_DIR}/encodings_META"
    )
