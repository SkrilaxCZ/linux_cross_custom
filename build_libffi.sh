#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=libffi-3.0.13
export PACKAGE_ARGS="--disable-static"
export LOGFILE=libffi.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
