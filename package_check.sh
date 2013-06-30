#!/bin/bash

export ROOT_DIR=/home/skrilax/arm/build
export SRC_DIR=/home/skrilax/arm/src

## TEST VARIABLES

if [ "$ARCH" == "" ]; then
	echo "ARCH is not defined"
	exit 1
fi

if [ "$VENDOR" == "" ]; then
	echo "VENDOR is not defined"
	exit 1
fi

if [ "$SYSTEM" == "" ]; then
	echo "SYSTEM is not defined"
	exit 1
fi

if [ "$LOGFILE" == "" ]; then
	echo "LOGFILE is not defined"
	exit 1
fi

export TRIPLET=$ARCH-$VENDOR-$SYSTEM

if [ ! -d $ROOT_DIR/$TRIPLET/sysroot ]; then
	echo "SYSROOT $ROOT_DIR/$TRIPLET/sysroot does not exist! Build toolchain first!"
fi

if [ ! -d $ROOT_DIR/$TRIPLET/obj ]; then
	echo "OBJ $ROOT_DIR/$TRIPLET/obj does not exist! Build toolchain first!"
fi

if [ ! -d $ROOT_DIR/$TRIPLET/tools ]; then
	echo "TOOLS $ROOT_DIR/$TRIPLET/tools does not exist! Build toolchain first!"
fi

if [ ! -d $ROOT_DIR/$TRIPLET/host ]; then
	echo "HOST $ROOT_DIR/$TRIPLET/host does not exist! Build toolchain first!"
fi

# UPDATE PATH
export PATH="$ROOT_DIR/$TRIPLET/tools/bin:$PATH"

# CREATE LOG
export LOG=$ROOT_DIR/$TRIPLET/$LOGFILE

touch $LOG

echo "ARCH = $ARCH" >> $LOG
echo "VENDOR = $VENDOR" >> $LOG
echo "SYSTEM = $SYSTEM" >> $LOG
echo "TRIPLET = $TRIPLET" >> $LOG
echo "PATH = $PATH" >> $LOG
echo "==============================================================================" >> $LOG
