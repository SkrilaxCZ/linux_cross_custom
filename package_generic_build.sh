#!/bin/bash

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
mkdir $PACKAGE
cd $PACKAGE

rm -rf $LOG
touch $LOG

echo "Configuring $PACKAGE" >> $LOG
echo "$SRC_DIR/$PACKAGE/configure --prefix=/usr --host=$TRIPLET $PACKAGE_ARGS" >> $LOG
eval $SRC_DIR/$PACKAGE/configure --prefix=/usr --host=$TRIPLET $PACKAGE_ARGS

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
echo "make prefix=$ROOT_DIR/$TRIPLET/sysroot/usr install" >> $LOG
eval make prefix=$ROOT_DIR/$TRIPLET/sysroot/usr install

if [ $? -ne 0 ]; then
	echo "$PACKAGE installing failed!" >> $LOG
	echo "$PACKAGE installing failed!"
	exit 1
fi
