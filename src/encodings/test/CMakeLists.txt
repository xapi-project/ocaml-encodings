add_ocaml_executable( encodings-test
    SOURCES encodings_test
    LIBRARIES encodings ocamltest
    RUN_POST_BUILD
    )
