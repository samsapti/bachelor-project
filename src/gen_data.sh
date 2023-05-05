#!/usr/bin/env bash

set -eo pipefail

patient_pref() {
    printf '%d %d' "-100" "$1"
}

therapist_pref() {
    printf '%d %d' "-200" "$1"
}

secret_share() {
    local secret="$1"
    export share_0="$(( RANDOM % (secret / 2 + 1) ))"
    export share_1="$(( RANDOM % (secret / 2 + 1) ))"
    export share_2="$(( secret - (share_0 + share_1) ))"
}

max_case=5
iter="$1"

for _ in $(seq "$iter"); do
    rand="$(( (RANDOM % max_case) + 1 ))"
    secret_share "$rand"
    p_data_s+=( "$rand" )

    for j in $(seq 0 2); do
        eval 'p_data_'$j'+=( $(patient_pref "$share_'$j'") )'
    done
done

t_data_s=( $(shuf -e "${p_data_s[@]}") )

for i in $(seq 0 "$(( iter - 1 ))"); do
    secret_share "${t_data_s[$i]}"

    for j in $(seq 0 2); do
        eval 't_data_'$j'+=( $(therapist_pref "$share_'$j'") )'
    done
done

for i in $(seq 0 2); do
    eval 'echo "${p_data_'$i'[*]} ${t_data_'$i'[*]}" > MP-SPDZ/Player-Data/Input-P'$i'-0'
done
