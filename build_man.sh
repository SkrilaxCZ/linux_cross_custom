#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=man-1.6g
export PACKAGE_ARGS="-confdir=/etc -mandir=/usr/share/man"
export PACKAGE_OMIT_CONFIG_HOST="1"
export PACKAGE_COPY_SOURCE="1"
export PACKAGE_INSTALL_USE_DESTDIR="1"
export LOGFILE=man.log
export BUILD_CC=`which gcc`

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
