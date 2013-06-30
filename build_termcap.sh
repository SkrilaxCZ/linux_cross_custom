#!/bin/bash

## VARIABLES

export ROOT_DIR=/home/skrilax/arm/build
export SRC_DIR=/home/skrilax/arm/src

export PACKAGE=termcap-1.3.1
export LOGFILE=termcap.log

## Package
source $SRC_DIR/package_check.sh
$SRC_DIR/package_generic_build.sh
