#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=mpc-1.0.1
export LOGFILE=mpc.log

## Package
source $SRC_DIR/package_check.sh
export PACKAGE_ARGS="CC=$TRIPLET-gcc CXX=$TRIPLET-gcc AS=$TRIPLET-as LD=$TRIPLET-ld"

$SRC_DIR/package_generic_build.sh
