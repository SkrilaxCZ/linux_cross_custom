#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=bzip2-1.0.6
export PACKAGE_INSTALL_USE_DESTDIR="1"
export LOGFILE=bzip2.log

## Package
source $SRC_DIR/package_check.sh
source $SRC_DIR/package_build_func.sh

verify_variables

cd $ROOT_DIR/$TRIPLET/obj
rm -rf $PACKAGE

cp -a $SRC_DIR/$PACKAGE $ROOT_DIR/$TRIPLET/obj
cd $PACKAGE

make_package

install_package
