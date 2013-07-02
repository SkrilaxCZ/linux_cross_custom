#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=pkg-config-0.28
export PACKAGE_ARGS="--docdir=/usr/share/doc/pkg-config-0.28 --disable-host-tool"
export LOGFILE=pkgconfig.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
