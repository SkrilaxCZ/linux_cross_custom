#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=pkg-config-0.28
export LOGFILE=pkgconfig.log

## Package
source $SRC_DIR/package_check.sh
export PACKAGE_ARGS="--docdir=$ROOT_DIR/$TRIPLET/sysroot/usr/share/doc/pkg-config-0.28 --disable-host-tool"
$SRC_DIR/package_generic_build.sh
