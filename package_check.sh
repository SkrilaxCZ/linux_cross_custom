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

# PKG CONFIG
export PKG_CONFIG_DIR=
export PKG_CONFIG_SYSROOT_DIR=$ROOT_DIR/$TRIPLET/sysroot
export PKG_CONFIG_LIBDIR=$PKG_CONFIG_SYSROOT_DIR/usr/lib/pkgconfig:$PKG_CONFIG_SYSROOT_DIR/usr/share/pkgconfig

# CREATE LOG
export LOG=$ROOT_DIR/$TRIPLET/$LOGFILE

rm -rf $LOG
touch $LOG

rm -rf $LOG.build
touch $LOG.build

# OPTIONAL VARIABLES
if [ "$PACKAGE_PREFIX" == "" ]; then
	export PACKAGE_PREFIX=/usr
fi

echo "ARCH = $ARCH" >> $LOG
echo "VENDOR = $VENDOR" >> $LOG
echo "SYSTEM = $SYSTEM" >> $LOG
echo "TRIPLET = $TRIPLET" >> $LOG
echo "PACKAGE = $PACKAGE" >> $LOG
echo "PACKAGE_ARGS = $PACKAGE_ARGS" >> $LOG
echo "PACKAGE_CONFIG_CACHE = $PACKAGE_CONFIG_CACHE" >> $LOG
echo "PACKAGE_PREFIX = $PACKAGE_PREFIX" >> $LOG
echo "PACKAGE_OMIT_CONFIG_HOST = $PACKAGE_OMIT_CONFIG_HOST" >> $LOG
echo "PACKAGE_INSTALL_USE_DESTDIR = $PACKAGE_INSTALL_USE_DESTDIR" >> $LOG
echo "PACKAGE_COPY_SOURCE = $PACKAGE_COPY_SOURCE" >> $LOG
echo "PATH = $PATH" >> $LOG
echo "==============================================================================" >> $LOG
