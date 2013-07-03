#!/bin/bash

export SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$SRC_DIR/../build
export PACKAGE=coreutils-8.21

# Log command
$SRC_DIR/log_command.sh "$@"

# Make dummy manual
shift
$SRC_DIR/$PACKAGE/man/dummy-man "$@"
