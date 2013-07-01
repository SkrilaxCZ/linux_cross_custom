#!/bin/bash

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

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
