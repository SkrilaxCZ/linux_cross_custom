#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=gmp-5.1.2
export PACKAGE_ARGS="--enable-cxx"
export LOGFILE=gmp.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
