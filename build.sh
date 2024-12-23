#!/bin/bash

AS_FLAGS="-arch arm64"

[ ! -d ./build ] && mkdir build
[ ! -d ./build/obj ] && mkdir build/obj
[ ! -d ./build/bin ] && mkdir build/bin

function build() {
    file_name=$(basename "$1")   
    file_base=${file_name%.*}    

    as $AS_FLAGS "$1" -o "./build/obj/$file_base.o"
    ld "./build/obj/$file_base.o" -o "./build/bin/$file_base"
}

for asm in ./src/*.s; do
    build "$asm"
done
