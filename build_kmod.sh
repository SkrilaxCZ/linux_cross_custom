#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=kmod-13
export PACKAGE_ARGS="--bindir=/sbin --sysconfdir=/etc --with-rootlibdir=/lib --with-zlib --with-xz"
export PACKAGE_INSTALL_USE_DESTDIR="1"
export LOGFILE=kmod.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
