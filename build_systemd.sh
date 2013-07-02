#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=systemd-204
export LOGFILE=systemd.log

## Package
source $SRC_DIR/package_check.sh
export PACKAGE_ARGS="--with-libgcrypt-prefix=$ROOT_DIR/$TRIPLET/sysroot/usr --disable-nls --with-distro=other --libexecdir=/usr/lib --localstatedir=/var --sysconfdir=/etc"
$SRC_DIR/package_generic_build.sh
