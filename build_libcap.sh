#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=libcap-2.20
export LOGFILE=libcap.log

## Package
source $SRC_DIR/package_check.sh
source $SRC_DIR/package_build_func.sh

verify_variables

## CONFIGURE

cd $ROOT_DIR/$TRIPLET/obj
rm -rf $PACKAGE

cp -a $SRC_DIR/$PACKAGE $ROOT_DIR/$TRIPLET/obj
cd $PACKAGE

## Fix rules
sed -i "s/CROSS_COMPILE ?=/CROSS_COMPILE := $TRIPLET-/" Make.Rules

## BUILD

make_package 

install_package

## Check if we have screwed and linstalled to lib64 instead of lib, this is a hack
if [ -d $ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX/lib64 ]; then
	mv $ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX/lib64/libcap* $ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX/lib/
	# try removing the directory
	rmdir $ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX/lib64
fi
