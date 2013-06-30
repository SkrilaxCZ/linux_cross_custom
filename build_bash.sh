#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=bash-4.2
export PACKAGE_ARGS="--without-bash-malloc --with-installed-readline"
export PACKAGE_CONFIG_CACHE="/tmp/bash.cache"
export PACKAGE_PREFIX=/
export LOGFILE=bash.log

# Config cache
cat > $PACKAGE_CONFIG_CACHE << "EOF"
ac_cv_func_mmap_fixed_mapped=yes
ac_cv_func_strcoll_works=yes
ac_cv_func_working_mktime=yes
bash_cv_func_sigsetjmp=present
bash_cv_getcwd_malloc=yes
bash_cv_job_control_missing=present
bash_cv_printf_a_format=yes
bash_cv_sys_named_pipes=present
bash_cv_ulimit_maxfds=yes
bash_cv_under_sys_siglist=yes
bash_cv_unusable_rtsigs=no
gt_cv_int_divbyzero_sigfpe=yes
EOF

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh

## Post install
cp -a $ROOT_DIR/$TRIPLET/sysroot/share/* $ROOT_DIR/$TRIPLET/sysroot/usr/share/
rm -Rf $ROOT_DIR/$TRIPLET/sysroot/share
