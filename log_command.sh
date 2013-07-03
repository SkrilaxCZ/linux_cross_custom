#!/bin/bash

# Print the commands to the specified logfile
if [ ! -f "$1" ]; then
	echo "File $1 not found!"
	exit 1
fi

FILE="$1"
shift

echo "Logging: $@"
echo "$@" >> "$FILE"
