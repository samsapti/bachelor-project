#!/usr/bin/env bash

cd MP-SPDZ

for i in $(seq 0 2); do
    eval ".//semi-party.x -N 3 -p $i gale_shapley > ../out-p$i.txt 2>&1 &"
done
