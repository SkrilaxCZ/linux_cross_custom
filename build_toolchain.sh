#!/bin/bash

## VARIABLES

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$SRC_DIR/../build

BINUTILS=binutils-2.23.2
GCC=gcc-4.7.3
GCC_STATIC=$GCC-static
GLIBC=eglibc-2.17
NEWLIB=newlib-2.0.0

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

if [ "$LIBC" == "" ]; then
	echo "LIBC is not defined"
	exit 1
fi

case "$LIBC" in
	glibc)
		echo "Using $GLIBC as C library, building with dynamic linking support!"
		;;
	newlib)
		echo "Using $NEWLIB as C library, building without dynamic linking support!"
		;;
	*)
		echo "$LIBC - unknown C library! Use \"glibc\" or \"newlib\"!"
		exit 1;
		;;
esac

if [ "$KERNEL" == "" ] && [ "$LIBC" == "glibc" ]; then
	echo "KERNEL is not defined, required for $GLIBC!"
	exit 1
fi

if [ ! -d $SRC_DIR/$KERNEL ] && [ "$LIBC" == "glibc" ]; then
	echo "$KERNEL directory does not exist!"
	exit 1
fi

TRIPLET=$ARCH-$VENDOR-$SYSTEM

## CREATE DIRECTORY STRUCTURE

if [ -d $ROOT_DIR/$TRIPLET ]; then
	echo "Root directory exists!"
	echo "Manually \"rm -rf $ROOT_DIR/$TRIPLET\"!"
	exit 1
fi

if [ ! -d $ROOT_DIR ]; then
	mkdir $ROOT_DIR
fi

mkdir $ROOT_DIR/$TRIPLET

SYSROOT=$ROOT_DIR/$TRIPLET/sysroot
OBJ_DIR=$ROOT_DIR/$TRIPLET/obj
PREFIX=$ROOT_DIR/$TRIPLET/tools
HOST=$ROOT_DIR/$TRIPLET/host

mkdir $PREFIX
mkdir $OBJ_DIR
mkdir $SYSROOT
mkdir $HOST

mkdir $SYSROOT/usr
mkdir $SYSROOT/usr/include

LOG=$ROOT_DIR/$TRIPLET/toolchain.log

touch $LOG

echo "ARCH = $ARCH" >> $LOG
echo "VENDOR = $VENDOR" >> $LOG
echo "SYSTEM = $SYSTEM" >> $LOG
echo "KERNEL = $KERNEL" >> $LOG
echo "LIBC = $LIBC" >> $LOG
echo "GCC_ARGS = $GCC_ARGS" >> $LOG
echo "LIBC_ARGS = $LIBC_ARGS" >> $LOG

echo "TRIPLET = $TRIPLET" >> $LOG
echo "==============================================================================" >> $LOG

## BUILD BINUTILS
## =========================================================================================================================================

build_binutils()
{
	cd $OBJ_DIR
	mkdir $BINUTILS
	cd $BINUTILS
	
	echo "Configuring $BINUTILS" >> $LOG
	echo "$SRC_DIR/$BINUTILS/configure --with-gnu-as --with-gnu-ld --disable-nls --target=$TRIPLET --with-sysroot=$SYSROOT --prefix=$PREFIX" >> $LOG
	eval $SRC_DIR/$BINUTILS/configure --with-gnu-as --with-gnu-ld --disable-nls --target=$TRIPLET --with-sysroot=$SYSROOT --prefix=$PREFIX
	
	if [ $? -ne 0 ]; then
		echo "$BINUTILS configuring failed!" >> $LOG
		echo "$BINUTILS configuring failed!"
		exit 1
	fi
	
	echo "Compiling $BINUTILS" >> $LOG
	make
	
	if [ $? -ne 0 ]; then
		echo "$BINUTILS compiling failed!" >> $LOG
		echo "$BINUTILS compiling failed!"
		exit 1
	fi
	
	echo "Installing $BINUTILS" >> $LOG
	make install
	
	if [ $? -ne 0 ]; then
		echo "$BINUTILS installing failed!" >> $LOG
		echo "$BINUTILS installing failed!"
		exit 1
	fi
}

## BUILD GCC - STATIC
## =========================================================================================================================================

build_gcc_static()
{
	cd $OBJ_DIR
	mkdir $GCC_STATIC
	cd $GCC_STATIC
	
	echo "Configuring $GCC_STATIC" >> $LOG	
	echo "$SRC_DIR/$GCC/configure --with-gnu-as --with-gnu-ld --with-sysroot=$SYSROOT --prefix=$PREFIX --target=$TRIPLET --disable-shared --enable-interwork --disable-multilib --enable-languages=c --disable-nls $GCC_LIBC_ARGS $GCC_ARGS" >> $LOG
	eval $SRC_DIR/$GCC/configure --with-gnu-as --with-gnu-ld --with-sysroot=$SYSROOT --prefix=$PREFIX --target=$TRIPLET --disable-shared --enable-interwork --disable-multilib --enable-languages=c --disable-nls $GCC_LIBC_ARGS $GCC_ARGS
	
	if [ $? -ne 0 ]; then
		echo "$GCC_STATIC configuring failed!" >> $LOG
		echo "$GCC_STATIC configuring failed!"
		exit 1
	fi
	
	echo "Compiling $GCC_STATIC - gcc" >> $LOG
	make all-gcc
	
	if [ $? -ne 0 ]; then
		echo "$GCC_STATIC - gcc compiling failed!" >> $LOG
		echo "$GCC_STATIC - gcc compiling failed!"
		exit 1
	fi
	
	echo "Installing $GCC_STATIC - gcc" >> $LOG
	make install-gcc
	
	if [ $? -ne 0 ]; then
		echo "$GCC_STATIC - gcc installing failed!" >> $LOG
		echo "$GCC_STATIC - gcc installing failed!"
		exit 1
	fi
}

## KERNEL: HEADERS
## =========================================================================================================================================

export_headers_kernel()
{
	cd $SRC_DIR/$KERNEL
	
	echo "Installing headers for $KERNEL" >> $LOG
	echo "make ARCH=$ARCH INSTALL_HDR_PATH=$SYSROOT/usr headers_install" >> $LOG 
	make ARCH=$ARCH INSTALL_HDR_PATH=$SYSROOT/usr headers_install
	
	if [ $? -ne 0 ]; then
		echo "$KERNEL installing headers failed!" >> $LOG
		echo "$KERNEL installing headers failed!"
		exit 1
	fi
	
	KERNEL_VERSION=`make kernelversion`
	
	if [ $? -ne 0 ]; then
		echo "$KERNEL failed reading version!" >> $LOG
		echo "$KERNEL failed reading version!"
		exit 1
	fi
	
	echo "Kernel version: $KERNEL_VERSION" >> $LOG
}

## GLIBC: HEADERS
## =========================================================================================================================================

export_headers_glibc()
{
	cd $OBJ_DIR
	mkdir $GLIBC
	cd $GLIBC
	
	echo "Configuring $GLIBC" >> $LOG
	echo "$SRC_DIR/$GLIBC/configure --target=$TRIPLET --prefix=/usr --enable-add-ons=libidn,nptl,ports --enable-obsolete-rpc libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes --disable-profile --host=$TRIPLET --enable-kernel=$KERNEL_VERSION --with-tls $LIBC_ARGS" >> $LOG
	eval $SRC_DIR/$GLIBC/configure --target=$TRIPLET --prefix=/usr --enable-add-ons=libidn,nptl,ports --enable-obsolete-rpc libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes --disable-profile --host=$TRIPLET --enable-kernel=$KERNEL_VERSION --with-tls $LIBC_ARGS
	
	if [ $? -ne 0 ]; then
		echo "$GLIBC configuring failed!" >> $LOG
		echo "$GLIBC configuring failed!"
		exit 1
	fi
	
	echo "Installing headers for $GLIBC" >> $LOG
	echo "make cross_compiling=yes install_root=$SYSROOT install-headers" >> $LOG
	make cross_compiling=yes install_root=$SYSROOT install-headers
	
	if [ $? -ne 0 ]; then
		echo "$GLIBC installing headers failed!" >> $LOG
		echo "$GLIBC installing headers failed!"
		exit 1
	fi
	
	# STUBS
	echo "Touching stubs" >> $LOG
	touch $SYSROOT/usr/include/gnu/stubs.h
	touch $SYSROOT/usr/include/gnu/stubs-hard.h
}

## BUILD LIBGCC - STATIC
## =========================================================================================================================================

build_libgcc_static()
{
	cd $OBJ_DIR/$GCC_STATIC
	
	echo "Compiling $GCC_STATIC - libgcc" >> $LOG
	make all-target-libgcc
	
	if [ $? -ne 0 ]; then
		echo "$GCC_STATIC - libgcc compiling failed!" >> $LOG
		echo "$GCC_STATIC - libgcc compiling failed!"
		exit 1
	fi
	
	echo "Installing $GCC_STATIC - libgcc" >> $LOG
	make install-target-libgcc
	
	if [ $? -ne 0 ]; then
		echo "$GCC_STATIC - libgcc installing failed!" >> $LOG
		echo "$GCC_STATIC - libgcc installing failed!"
		exit 1
	fi
}

## BUILD GLIBC
## =========================================================================================================================================

build_glibc()
{
	cd $OBJ_DIR/$GLIBC
	
	echo "Compiling $GLIBC" >> $LOG
	make cross_compiling=yes
	
	if [ $? -ne 0 ]; then
		echo "$GLIBC compiling failed!" >> $LOG
		echo "$GLIBC compiling failed!"
		exit 1
	fi
	
	echo "Installing $GLIBC" >> $LOG
	make install_root=$SYSROOT install
	
	if [ $? -ne 0 ]; then
		echo "$GLIBC - libgcc installing failed!" >> $LOG
		echo "$GLIBC - libgcc installing failed!"
		exit 1
	fi
}

## BUILD GCC
## =========================================================================================================================================

build_gcc()
{
	cd $OBJ_DIR
	mkdir $GCC
	cd $GCC
	
	echo "Configuring $GCC" >> $LOG
	echo "$SRC_DIR/$GCC/configure --with-gnu-as --with-gnu-ld --with-sysroot=$SYSROOT --prefix=$PREFIX --target=$TRIPLET --enable-interwork --disable-multilib --enable-languages=c,c++ --disable-nls $GCC_ARGS" >> $LOG
	eval $SRC_DIR/$GCC/configure --with-gnu-as --with-gnu-ld --with-sysroot=$SYSROOT --prefix=$PREFIX --target=$TRIPLET --enable-interwork --disable-multilib --enable-languages=c,c++ --disable-nls $GCC_ARGS
	
	if [ $? -ne 0 ]; then
		echo "$GCC configuring failed!" >> $LOG
		echo "$GCC configuring failed!"
		exit 1
	fi
	
	echo "Compiling $GCC" >> $LOG
	make all
	
	if [ $? -ne 0 ]; then
		echo "$GCC compiling failed!" >> $LOG
		echo "$GCC compiling failed!"
		exit 1
	fi
	
	echo "Installing $GCC" >> $LOG
	make install
	
	if [ $? -ne 0 ]; then
		echo "$GCC installing failed!" >> $LOG
		echo "$GCC installing failed!"
		exit 1
	fi
}

## BUILD NEWLIB
## =========================================================================================================================================

build_newlib()
{
	cd $OBJ_DIR
	mkdir $NEWLIB
	cd $NEWLIB

	echo "Configuring $NEWLIB" >> $LOG
	echo "$SRC_DIR/$NEWLIB/configure --target=$TRIPLET --prefix=$SYSROOT/usr --disable-newlib-supplied-syscalls --disable-multilib $LIBC_ARGS" >> $LOG
	eval $SRC_DIR/$NEWLIB/configure --target=$TRIPLET --prefix=$SYSROOT/usr --disable-newlib-supplied-syscalls --disable-multilib $LIBC_ARGS

	if [ $? -ne 0 ]; then
		echo "$NEWLIB configuring failed!" >> $LOG
		echo "$NEWLIB configuring failed!"
		exit 1
	fi
	
	echo "Compiling $NEWLIB" >> $LOG
	make
	
	if [ $? -ne 0 ]; then
		echo "$NEWLIB compiling failed!" >> $LOG
		echo "$NEWLIB compiling failed!"
		exit 1
	fi
	
	echo "Installing $NEWLIB" >> $LOG
	make install
	
	if [ $? -ne 0 ]; then
		echo "$NEWLIB installing failed!" >> $LOG
		echo "$NEWLIB installing failed!"
		exit 1
	fi
	
	echo "Sanitizing sysroot" >> $LOG
	if [ ! -d $SYSROOT/usr/include ]; then
		mv $SYSROOT/usr/$TRIPLET/include $SYSROOT/usr/
	else
		cp -a $SYSROOT/usr/$TRIPLET/include/* $SYSROOT/usr/include/
	fi

	if [ ! -d $SYSROOT/usr/lib ]; then
		mv $SYSROOT/usr/$TRIPLET/lib $SYSROOT/usr/
	else
		cp -a $SYSROOT/usr/$TRIPLET/lib/* $SYSROOT/usr/lib/
	fi
	
	rm -rf $SYSROOT/usr/$TRIPLET
}

## SCRIPT
## =========================================================================================================================================

build_binutils

if [ "$LIBC" == "newlib" ]; then
	GCC_LIBC_ARGS="--with-newlib"
fi

build_gcc_static

# UPDATE PATH
export PATH="$PREFIX/bin:$PATH"

echo "Updating PATH!" >> $LOG
echo "PATH=$PATH" >> $LOG

case "$LIBC" in
	glibc)
			export_headers_kernel
			export_headers_glibc
		;;
	newlib)
			build_newlib
		;;
esac

build_libgcc_static

if [ "$LIBC" == "glibc" ]; then
	build_glibc
	build_gcc
fi

echo "Done." >> $LOG
echo "Done."
