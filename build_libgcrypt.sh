#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=libgcrypt-1.5.2
export PACKAGE_ARGS="--disable-static"
export LOGFILE=libgcrypt.log

## Package
source $SRC_DIR/package_check.sh
export GPG_ERROR_CONFIG=$ROOT_DIR/$TRIPLET/sysroot/usr/bin/gpg-error-config
export GPG_ERROR_LIBS="-lgpg-error"
$SRC_DIR/package_generic_build.sh
