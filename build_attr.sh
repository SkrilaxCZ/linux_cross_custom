#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=attr-2.4.47
export PACKAGE_COPY_SOURCE=1
export PACKAGE_ARGS="--disable-static"
export LOGFILE=attr.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh

## Move it to /lib
if [ $? -ne 0 ]; then exit 1; fi

## Fix install
cp -a $ROOT_DIR/$TRIPLET/obj/$PACKAGE/libattr/.libs/libattr* $ROOT_DIR/$TRIPLET/sysroot/lib
rm -f $ROOT_DIR/$TRIPLET/sysroot/lib/libattr.la
mv $ROOT_DIR/$TRIPLET/sysroot/lib/libattr.lai $ROOT_DIR/$TRIPLET/sysroot/lib/libattr.la
ln -s ../../lib/libattr.so.1.1.0 $ROOT_DIR/$TRIPLET/sysroot/usr/lib/libattr.so
