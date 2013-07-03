#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=busybox-1.21.1
export LOGFILE=busybox.log

# Check it
source $SRC_DIR/package_check.sh

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
mkdir $PACKAGE
cd $SRC_DIR/$PACKAGE

rm -rf $LOG
touch $LOG

rm -rf $LOG.build
touch $LOG.build

echo "Configuring $PACKAGE" >> $LOG
echo "make defconfig" >> $LOG
make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE defconfig 2>&1 | tee -a $LOG.build

if [ $PIPESTATUS -ne 0 ]; then
	echo "$PACKAGE configuring failed!" >> $LOG
	echo "$PACKAGE configuring failed!"
	exit 1
fi

## MAKE
eval "make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE"
make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE 2>&1 | tee -a $LOG.build

if [ $PIPESTATUS -ne 0 ]; then
	echo "$PACKAGE compiling failed!" >> $LOG
	echo "$PACKAGE compiling failed!"
	exit 1
fi

## INSTALL
eval "make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE install"
make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE install 2>&1 | tee -a $LOG.build
cp -a $ROOT_DIR/$TRIPLET/obj/$PACKAGE/_install/* $ROOT_DIR/$TRIPLET/sysroot/
rm -f $ROOT_DIR/$TRIPLET/sysroot/linuxrc

if [ $PIPESTATUS -ne 0 ]; then
	echo "$PACKAGE installing failed!" >> $LOG
	echo "$PACKAGE installing failed!"
	exit 1
fi
