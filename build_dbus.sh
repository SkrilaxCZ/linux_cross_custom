#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=dbus-1.6.12
export PACKAGE_ARGS="--sysconfdir=/etc --localstatedir=/var --libexecdir=/usr/lib/dbus-1.0 --with-console-auth-dir=/run/console --without-x --enable-abstract-sockets --disable-static"
export PACKAGE_INSTALL_USE_DESTDIR=1
export LOGFILE=dbus.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
