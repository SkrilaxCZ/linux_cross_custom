#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=gawk-4.1.0
export PACKAGE_ARGS="--disable-nls --libexecdir=/usr/lib --disable-libsigsegv --with-readline --with-mpfr"
export PACKAGE_INSTALL_USE_DESTDIR="1"
export LOGFILE=gawk.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
