#!/bin/bash

## VARIABLES

export ROOT_DIR=/home/skrilax/arm/build
export SRC_DIR=/home/skrilax/arm/src

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

echo "Configuring $PACKAGE" >> $LOG
echo "make defconfig" >> $LOG
make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE defconfig

if [ $? -ne 0 ]; then
	echo "$PACKAGE configuring failed!" >> $LOG
	echo "$PACKAGE configuring failed!"
	exit 1
fi

## MAKE
eval "make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE"
make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE

if [ $? -ne 0 ]; then
	echo "$PACKAGE compiling failed!" >> $LOG
	echo "$PACKAGE compiling failed!"
	exit 1
fi

## INSTALL
eval "make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE install"
make CROSS_COMPILE=$TRIPLET- O=$ROOT_DIR/$TRIPLET/obj/$PACKAGE install
cp -a $ROOT_DIR/$TRIPLET/obj/$PACKAGE/_install/* $ROOT_DIR/$TRIPLET/sysroot/
rm -f $ROOT_DIR/$TRIPLET/sysroot/linuxrc

if [ $? -ne 0 ]; then
	echo "$PACKAGE installing failed!" >> $LOG
	echo "$PACKAGE installing failed!"
	exit 1
fi
