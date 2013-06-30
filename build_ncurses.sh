#!/bin/bash

## VARIABLES

export ROOT_DIR=/home/skrilax/arm/build
export SRC_DIR=/home/skrilax/arm/src

export PACKAGE=ncurses-5.9
export LOGFILE=ncurses.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
