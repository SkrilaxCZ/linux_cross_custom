#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=libcap-2.20
export LOGFILE=libcap.log

## Package
source $SRC_DIR/package_check.sh

## TEST

if [ "$PACKAGE" == "" ]; then
	echo "PACKAGE is not defined"
	exit 1
fi

if [ "$SRC_DIR" == "" ]; then
	echo "SRC_DIR is not defined"
	exit 1
fi

if [ "$ROOT_DIR" == "" ]; then
	echo "ROOT_DIR is not defined"
	exit 1
fi

if [ "$TRIPLET" == "" ]; then
	echo "TRIPLET is not defined"
	exit 1
fi

if [ "$LOG" == "" ]; then
	echo "LOG is not defined"
	exit 1
fi

if [ ! -d $ROOT_DIR/$TRIPLET/obj ]; then
	echo "OBJ $ROOT_DIR/$TRIPLET/obj does not exist! Build toolchain first!"
fi

## CONFIGURE

cd $ROOT_DIR/$TRIPLET/obj
rm -rf $PACKAGE

cp -a $SRC_DIR/$PACKAGE $ROOT_DIR/$TRIPLET/obj
cd $PACKAGE

if [ "$PACKAGE_PREFIX" == "" ]; then
	PACKAGE_PREFIX=/usr
fi

## Fix rules
sed -i "s/CROSS_COMPILE ?=/CROSS_COMPILE := $TRIPLET-/" Make.Rules

## MAKE
echo "make prefix=$PACKAGE_PREFIX" >> $LOG
make prefix=$PACKAGE_PREFIX

if [ $? -ne 0 ]; then
	echo "$PACKAGE compiling failed!" >> $LOG
	echo "$PACKAGE compiling failed!"
	exit 1
fi

## INSTALL
echo "make prefix=$ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX install" >> $LOG
eval make prefix=$ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX install

if [ $? -ne 0 ]; then
	echo "$PACKAGE installing failed!" >> $LOG
	echo "$PACKAGE installing failed!"
	exit 1
fi

## Check if we have screwed and linstalled to lib64 instead of lib, this is a hack
if [ -d $ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX/lib64 ]; then
	mv $ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX/lib64/libcap* $ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX/lib/
	# try removing the directory
	rmdir $ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX/lib64
fi

