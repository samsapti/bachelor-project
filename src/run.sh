#!/usr/bin/env bash

cd MP-SPDZ

if [[ $1 == "-k" ]]; then
    killall semi-party.x
    exit $?
fi

for i in $(seq 0 2); do
    ./semi-party.x -N 3 -p "$i" gale_shapley > "../out-p$i.txt" 2>&1 &
done
