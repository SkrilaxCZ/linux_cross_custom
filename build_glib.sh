#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=glib-2.37.0
export PACKAGE_ARGS="--disable-fam --disable-static"
export LOGFILE=glib.log
export PACKAGE_CONFIG_CACHE="/tmp/glib.cache"

## Package
source $SRC_DIR/package_check.sh

cat > $PACKAGE_CONFIG_CACHE << "EOF"
glib_cv_stack_grows=no
glib_cv_uscore=no
ac_cv_func_mmap_fixed_mapped=yes
ac_cv_func_posix_getpwuid_r=yes
ac_cv_func_posix_getgrgid_r=yes
EOF

export AUTOMAKE=`which automake`
export AUTOCONF=`which autoconf`
export AUTOHEADER=`which autoheader`
export ACLOCAL=`which aclocal`

$SRC_DIR/package_generic_build.sh
