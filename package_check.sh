#!/bin/bash

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

if [ "$SRC_DIR" == "" ]; then
	echo "SRC_DIR is not defined"
	exit 1
fi

if [ "$ROOT_DIR" == "" ]; then
	echo "ROOT_DIR is not defined"
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

rm -rf $LOG
touch $LOG

echo "ARCH = $ARCH" >> $LOG
echo "VENDOR = $VENDOR" >> $LOG
echo "SYSTEM = $SYSTEM" >> $LOG
echo "TRIPLET = $TRIPLET" >> $LOG
echo "PACKAGE = $PACKAGE" >> $LOG
echo "PACKAGE_ARGS = $PACKAGE_ARGS" >> $LOG
echo "PACKAGE_CONFIG_CACHE = $PACKAGE_CONFIG_CACHE" >> $LOG
echo "PACKAGE_PREFIX = $PACKAGE_PREFIX" >> $LOG
echo "PATH = $PATH" >> $LOG
echo "==============================================================================" >> $LOG
