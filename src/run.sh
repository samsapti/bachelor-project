#!/usr/bin/env bash

cd "$(dirname "$0")/MP-SPDZ" || exit 1

if [[ $1 == "-k" ]]; then
    killall semi2k-party.x
    exit $?
fi

for i in $(seq 0 2); do
    ./semi2k-party.x -v -N 3 -p "$i" -e gale_shapley > "../out-p$i.txt" 2>&1 &
done
