#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=mpfr-3.1.2
export PACKAGE_ARGS="--enable-shared"
export LOGFILE=mpfr.log

## Package
source $SRC_DIR/package_check.sh
export PACKAGE_ARGS="CC=$TRIPLET-gcc CXX=$TRIPLET-gcc AS=$TRIPLET-as LD=$TRIPLET-ld"

$SRC_DIR/package_generic_build.sh
