#!/bin/bash

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

BINUTILS=binutils-2.23.2
GCC=gcc-4.7.3

export LOGFILE=target_toolchain.log

## Package
source $SRC_DIR/package_check.sh

## BINUTILS

cd $ROOT_DIR/$TRIPLET/obj
rm -rf $BINUTILS-target
mkdir $BINUTILS-target
cd $BINUTILS-target

echo "Configuring $BINUTILS" >> $LOG
echo "$SRC_DIR/$BINUTILS/configure --with-gnu-as --with-gnu-ld --prefix=/usr --infodir=/usr/share/info --mandir=/usr/share/man --libdir=/usr/lib --libexecdir=/usr/lib --host=$TRIPLET --target=$TRIPLET --disable-nls" >> $LOG
eval $SRC_DIR/$BINUTILS/configure --with-gnu-as --with-gnu-ld --prefix=/usr --infodir=/usr/share/info --mandir=/usr/share/man --libdir=/usr/lib --libexecdir=/usr/lib --host=$TRIPLET --target=$TRIPLET --disable-nls

if [ $? -ne 0 ]; then
	echo "$BINUTILS configuring failed!" >> $LOG
	echo "$BINUTILS configuring failed!"
	exit 1
fi

echo "Compiling $BINUTILS" >> $LOG
echo "make all" >> $LOG
make all

if [ $? -ne 0 ]; then
	echo "$BINUTILS compiling failed!" >> $LOG
	echo "$BINUTILS compiling failed!"
	exit 1
fi

echo "Installing $BINUTILS" >> $LOG
echo "make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot install" >> $LOG
make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot install

if [ $? -ne 0 ]; then
	echo "$BINUTILS installing failed!" >> $LOG
	echo "$BINUTILS installing failed!"
	exit 1
fi

# Installation fixes
for util in ar as ld ld.bfd nm objcopy objdump ranlib strip; do
	rm -f $ROOT_DIR/$TRIPLET/sysroot/usr/$TRIPLET/bin/$util
	ln -s ../../bin/$util $ROOT_DIR/$TRIPLET/sysroot/usr/$TRIPLET/bin/$util
done

mv $ROOT_DIR/$TRIPLET/sysroot/usr/$TRIPLET/lib/ldscripts $ROOT_DIR/$TRIPLET/sysroot/usr/lib/
ln -s ../../lib/ldscripts $ROOT_DIR/$TRIPLET/sysroot/usr/$TRIPLET/lib/ldscripts

## GCC

cd $ROOT_DIR/$TRIPLET/obj
rm -rf $GCC-target
mkdir $GCC-target
cd $GCC-target

echo "Configuring $GCC" >> $LOG
echo "$SRC_DIR/$GCC/configure --with-gnu-as --with-gnu-ld --prefix=/usr --infodir=/usr/share/info --mandir=/usr/share/man --libdir=/usr/lib --libexecdir=/usr/lib --host=$TRIPLET --target=$TRIPLET --enable-interwork --disable-multilib --enable-languages=c,c++ --disable-nls $GCC_ARGS" >> $LOG
eval $SRC_DIR/$GCC/configure --with-gnu-as --with-gnu-ld --prefix=/usr --infodir=/usr/share/info --mandir=/usr/share/man --libdir=/usr/lib --libexecdir=/usr/lib --host=$TRIPLET --target=$TRIPLET --enable-interwork --disable-multilib --enable-languages=c,c++ --disable-nls $GCC_ARGS

if [ $? -ne 0 ]; then
	echo "$GCC configuring failed!" >> $LOG
	echo "$GCC configuring failed!"
	exit 1
fi

echo "Compiling $GCC" >> $LOG
echo "make all" >> $LOG
make all

if [ $? -ne 0 ]; then
	echo "$GCC compiling failed!" >> $LOG
	echo "$GCC compiling failed!"
	exit 1
fi

echo "Installing $GCC" >> $LOG
echo "make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot install" >> $LOG
make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot install

if [ $? -ne 0 ]; then
	echo "$GCC installing failed!" >> $LOG
	echo "$GCC installing failed!"
	exit 1
fi

# Installation fixes
rm -f $ROOT_DIR/$TRIPLET/sysroot/usr/bin/arm-cns3420-linux-gnueabihf-*
