#!/bin/bash

## VARIABLES

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build

# include functions

source $SRC_DIR/package_build_func.sh

verify_variables

configure_package

make_package

install_package
