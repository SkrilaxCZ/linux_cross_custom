#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=findutils-4.4.2
export PACKAGE_ARGS="--libexecdir=/usr/lib/locate --localstatedir=/var/lib/locate"
export PACKAGE_CONFIG_CACHE="/tmp/findutils.cache"
export PACKAGE_INSTALL_USE_DESTDIR="1"
export LOGFILE=findutils.log

cat > $PACKAGE_CONFIG_CACHE << EOF
gl_cv_func_wcwidth_works=yes
gl_cv_header_working_fcntl_h=yes
ac_cv_func_fnmatch_gnu=yes
EOF

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
