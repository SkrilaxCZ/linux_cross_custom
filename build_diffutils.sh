#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

export PACKAGE=diffutils-3.3
export LOGFILE=diffutils.log

## Package
source $SRC_DIR/package_check.sh

MANFILE=diffutils.frst
rm -rf $ROOT_DIR/$TRIPLET/$MANFILE
touch $ROOT_DIR/$TRIPLET/$MANFILE

export HELP2MAN="$SRC_DIR/log_command.sh $ROOT_DIR/$TRIPLET/$MANFILE"
$SRC_DIR/package_generic_build.sh
