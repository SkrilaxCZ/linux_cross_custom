#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=grep-2.14
export LOGFILE=grep.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
