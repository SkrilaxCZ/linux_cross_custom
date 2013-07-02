#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=e2fsprogs-1.42.8
export PACKAGE_ARGS="--with-root-prefix=\"\" --enable-elf-shlibs"
export PACKAGE_INSTALL_USE_DESTDIR="1"
export LOGFILE=e2fsprogs.log

## Package
source $SRC_DIR/package_check.sh
source $SRC_DIR/package_build_func.sh

verify_variables

configure_package

make_package

install_package

install_package_custom_cmd "install-libs"
