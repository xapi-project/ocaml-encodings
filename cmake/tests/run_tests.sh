#! /bin/bash

test_dirs=[0-9][0-9]*

function run_test () {
    rm -rf _build
    mkdir _build
    cd _build

    cmake ..
    make
}

for d in ${test_dirs}; do
    (cd $d; run_test)
done
