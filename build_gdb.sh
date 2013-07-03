#!/bin/bash

## VARIABLES

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$SRC_DIR/../build

GDB=gdb-7.6
GDB_SERVER=gdb-7.6-server
LOGFILE=gdb.log

## Package
PACKAGE=$GDB
source $SRC_DIR/package_check.sh

## BUILD GDB
## =========================================================================================================================================

cd $ROOT_DIR/$TRIPLET/obj
rm -rf $GDB
mkdir $GDB
cd $GDB

echo "Configuring $GDB" >> $LOG
echo "$SRC_DIR/$GDB/configure --prefix=$ROOT_DIR/$TRIPLET/host --target=$TRIPLET" >> $LOG
eval $SRC_DIR/$GDB/configure --prefix=$ROOT_DIR/$TRIPLET/host --target=$TRIPLET 2>&1 | tee -a $LOG.build

if [ $PIPESTATUS -ne 0 ]; then
	echo "$GDB configuring failed!" >> $LOG
	echo "$GDB configuring failed!"
	exit 1
fi

## MAKE
echo "make" >> $LOG
make 2>&1 | tee -a $LOG.build

if [ $PIPESTATUS -ne 0 ]; then
	echo "$GDB compiling failed!" >> $LOG
	echo "$GDB compiling failed!"
	exit 1
fi

## INSTALL
echo "make install" >> $LOG
make install 2>&1 | tee -a $LOG.build

if [ $PIPESTATUS -ne 0 ]; then
	echo "$GDB installing failed!" >> $LOG
	echo "$GDB installing failed!"
	exit 1
fi

## BUILD GDB SERVER
## =========================================================================================================================================

cd $ROOT_DIR/$TRIPLET/obj
rm -rf $GDB_SERVER
mkdir $GDB_SERVER
cd $GDB_SERVER

echo "Configuring $GDB_SERVER" >> $LOG
echo "$SRC_DIR/$GDB/gdb/gdbserver/configure --prefix=$ROOT_DIR/$TRIPLET/sysroot/usr --host=$TRIPLET" >> $LOG
eval $SRC_DIR/$GDB/gdb/gdbserver/configure --prefix=$ROOT_DIR/$TRIPLET/sysroot/usr --host=$TRIPLET 2>&1 | tee -a $LOG.build

if [ $PIPESTATUS -ne 0 ]; then
	echo "$GDB_SERVER configuring failed!" >> $LOG
	echo "$GDB_SERVER configuring failed!"
	exit 1
fi

## MAKE
echo "make" >> $LOG
make 2>&1 | tee -a $LOG.build

if [ $PIPESTATUS -ne 0 ]; then
	echo "$GDB_SERVER compiling failed!" >> $LOG
	echo "$GDB_SERVER compiling failed!"
	exit 1
fi

## INSTALL
echo "make install" >> $LOG
eval make install 2>&1 | tee -a $LOG.build

if [ $PIPESTATUS -ne 0 ]; then
	echo "$GDB_SERVER installing failed!" >> $LOG
	echo "$GDB_SERVER installing failed!"
	exit 1
fi
