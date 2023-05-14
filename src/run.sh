#!/usr/bin/env bash

PROG="semi2k-party.x"

if [[ $1 == "-k" ]]; then
    killall "$PROG"
    exit "$?"
fi

cd "$(dirname "$0")/MP-SPDZ" || exit 1

for i in $(seq 0 2); do
    "./$PROG" -v -N 3 -p "$i" -e gale_shapley > "../out-p$i.txt" 2>&1 &
done
