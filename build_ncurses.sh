#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=ncurses-5.9
export PACKAGE_ARGS="--with-shared --without-debug --without-ada --enable-overwrite --with-build-cc=gcc --mandir=\\\${prefix}/share/man"
export LOGFILE=ncurses.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
