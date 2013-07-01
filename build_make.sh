#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=make-3.82
export LOGFILE=make.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
