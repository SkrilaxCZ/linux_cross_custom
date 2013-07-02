#!/bin/bash

## Check variables

verify_variables()
{
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
}

## CONFIGURE

configure_package()
{
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
		HOST_ARGS="--host=$TRIPLET --with-sysroot=$ROOT_DIR/$TRIPLET/sysroot"
	fi

	echo "Configuring $PACKAGE" >> $LOG
	echo "$COMPILER_ARGS $CFG_ROOT/configure --prefix=$PACKAGE_PREFIX $HOST_ARGS $PACKAGE_ARGS" >> $LOG
	eval $COMPILER_ARGS $CFG_ROOT/configure --prefix=$PACKAGE_PREFIX $HOST_ARGS $PACKAGE_ARGS

	if [ $? -ne 0 ]; then
		echo "$PACKAGE configuring failed!" >> $LOG
		echo "$PACKAGE configuring failed!"
		exit 1
	fi
}

## MAKE
make_package_custom_cmd()
{
	echo "make $1" >> $LOG
	eval make $1

	if [ $? -ne 0 ]; then
		echo "$PACKAGE compiling failed!" >> $LOG
		echo "$PACKAGE compiling failed!"
		exit 1
	fi
}

make_package()
{
	make_package_custom_cmd ""
}

## INSTALL

install_package_custom_cmd()
{
	if [ "$1" == "" ]; then
		echo "$PACKAGE no install command specified!" >> $LOG
		exit 1
	fi
	
	if [ "$PACKAGE_INSTALL_USE_DESTDIR" == "1" ]; then
		echo "make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot $1" >> $LOG
		eval make DESTDIR=$ROOT_DIR/$TRIPLET/sysroot $1
	else
		echo "make prefix=$ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX $1" >> $LOG
		eval make prefix=$ROOT_DIR/$TRIPLET/sysroot$PACKAGE_PREFIX $1
	fi

	if [ $? -ne 0 ]; then
		echo "$PACKAGE installing failed!" >> $LOG
		echo "$PACKAGE installing failed!"
		exit 1
	fi
}

install_package()
{
	install_package_custom_cmd "install"
}
