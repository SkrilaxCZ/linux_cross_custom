#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=zlib-1.2.8
export PACKAGE_OMIT_CONFIG_HOST=1
export PACKAGE_COPY_SOURCE=1
export LOGFILE=zlib.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh

## Move it to /lib
if [ $? -ne 0 ]; then exit 1; fi

mv $ROOT_DIR/$TRIPLET/sysroot/usr/lib/libz.so* $ROOT_DIR/$TRIPLET/sysroot/lib/
ln -s ../../lib/libz.so.1.2.8 $ROOT_DIR/$TRIPLET/sysroot/usr/lib/libz.so
