#! /bin/bash

cmd=${1:-run}

test_dirs=[0-9][0-9]*

function clean_test () {
    rm -rf _build
}

function run_test () {
    mkdir _build
    cd _build

    cmake ..
    make
}

for d in ${test_dirs}; do
    (cd $d; clean_test)
done

[ "$cmd" == "no" ] && exit 0

for d in ${test_dirs}; do
    (cd $d; run_test)
done
