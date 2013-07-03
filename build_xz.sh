#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=xz-5.0.5
export LOGFILE=xz.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
