#!/bin/sh

MACHINE="$1"
shift
cd src/MP-SPDZ
"./$MACHINE" "$@"
