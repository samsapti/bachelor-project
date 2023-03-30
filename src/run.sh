#!/bin/sh

MACHINE="$1"
shift
cd MP-SPDZ
"./$MACHINE" "$@"
