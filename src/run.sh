#!/usr/bin/env sh

MACHINE="$1"
shift
cd MP-SPDZ
"./$MACHINE" "$@"
