#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=systemd-204
export LOGFILE=systemd.log
export PACKAGE_CONFIG_CACHE="/tmp/systemd.cache"
export PACKAGE_INSTALL_USE_DESTDIR="1"

# Config cache
cat > $PACKAGE_CONFIG_CACHE << "EOF"
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF

## Package
source $SRC_DIR/package_check.sh
export PACKAGE_ARGS="--with-libgcrypt-prefix=$ROOT_DIR/$TRIPLET/sysroot/usr --disable-nls --libexecdir=/usr/lib --localstatedir=/var --sysconfdir=/etc --without-python"
$SRC_DIR/package_generic_build.sh
