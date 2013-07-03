#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=coreutils-8.21
export PACKAGE_ARGS="--enable-install-program=hostname"
export PACKAGE_CONFIG_CACHE="/tmp/coreutils.cache"
export LOGFILE=coreutils.log

cat > $PACKAGE_CONFIG_CACHE << EOF
fu_cv_sys_stat_statfs2_bsize=yes
gl_cv_func_working_mkstemp=yes
EOF

## Package
source $SRC_DIR/package_check.sh
source $SRC_DIR/package_build_func.sh

verify_variables

configure_package

## Fix makefile
cd $ROOT_DIR/$TRIPLET/obj/$PACKAGE

## Manual for coreutils has to be generated on the host system, so log the command for firstboot
MANFILE=coreutils.frst
rm -rf $ROOT_DIR/$TRIPLET/$MANFILE
touch $ROOT_DIR/$TRIPLET/$MANFILE

sed -i 's:run_help2man = $(PERL) -- $(srcdir)/man/help2man:run_help2man = '$SRC_DIR/coreutils_hook_man.sh' '$ROOT_DIR/$TRIPLET/$MANFILE':' Makefile

make_package

install_package
