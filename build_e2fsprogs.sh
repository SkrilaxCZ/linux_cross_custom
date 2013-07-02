#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=e2fsprogs-1.42.8
export PACKAGE_ARGS="--with-root-prefix=\"\" --enable-elf-shlibs"
export LOGFILE=e2fsprogs.log

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

if [ "$PACKAGE_COPY_SOURCE" == "1" ]; then
	cp -a $SRC_DIR/$PACKAGE $ROOT_DIR/$TRIPLET/obj
	cd $PACKAGE
	CFG_ROOT=$ROOT_DIR/$TRIPLET/obj/$PACKAGE
else
	mkdir $PACKAGE
	cd $PACKAGE
	CFG_ROOT=$SRC_DIR/$PACKAGE
fi

if [ "$PACKAGE_CONFIG_CACHE" != "" ]; then
	if [ -f "$PACKAGE_CONFIG_CACHE" ]; then
		echo "Using config.cache from $PACKAGE_CONFIG_CACHE" >> $LOG
		cat $PACKAGE_CONFIG_CACHE >> $LOG
		mv $PACKAGE_CONFIG_CACHE config.cache
		PACKAGE_ARGS="$PACKAGE_ARGS --cache-file=config.cache"
	else
		echo "config.cache defined but not found!" >> $LOG
		echo "config.cache defined but not found!"
		exit 1
	fi
fi

if [ "$PACKAGE_PREFIX" == "" ]; then
	PACKAGE_PREFIX=/usr
fi

if [ "$PACKAGE_OMIT_CONFIG_HOST" == "1" ]; then
	COMPILER_ARGS="CC=$TRIPLET-gcc CXX=$TRIPLET-g++"
	HOST_ARGS=
else
	COMPILER_ARGS=
	HOST_ARGS="--host=$TRIPLET"
fi

echo "Configuring $PACKAGE" >> $LOG
echo "$COMPILER_ARGS $CFG_ROOT/configure --prefix=$PACKAGE_PREFIX $HOST_ARGS $PACKAGE_ARGS" >> $LOG
eval $COMPILER_ARGS $CFG_ROOT/configure --prefix=$PACKAGE_PREFIX $HOST_ARGS $PACKAGE_ARGS

if [ $? -ne 0 ]; then
	echo "$PACKAGE configuring failed!" >> $LOG
	echo "$PACKAGE configuring failed!"
	exit 1
fi

## MAKE
echo "make" >> $LOG
make

if [ $? -ne 0 ]; then
	echo "$PACKAGE compiling failed!" >> $LOG
	echo "$PACKAGE compiling failed!"
	exit 1
fi

## INSTALL
echo "make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot install" >> $LOG
eval make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot install

if [ $? -ne 0 ]; then
	echo "$PACKAGE installing failed!" >> $LOG
	echo "$PACKAGE installing failed!"
	exit 1
fi

echo "make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot install-libs" >> $LOG
eval make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot install-libs

if [ $? -ne 0 ]; then
	echo "$PACKAGE installing failed!" >> $LOG
	echo "$PACKAGE installing failed!"
	exit 1
fic
