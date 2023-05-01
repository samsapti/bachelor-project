#!/usr/bin/env bash

patient_pref() {
    printf '%d %d' "-100" "$1"
}

therapist_pref() {
    printf '%d %d' "-200" "$1"
}

secret_share() {
    local secret="$1"
    share_0="$(( RANDOM % (secret / 2 + 1) ))"
    share_1="$(( RANDOM % (secret / 2 + 1) ))"
    share_2="$(( secret - (share_0 + share_1) ))"
}

declare -a p_data_0
declare -a p_data_1
declare -a p_data_2
declare -a t_data_0
declare -a t_data_1
declare -a t_data_2

max_index=5

for _ in $(seq "$1"); do
    rand="$(( (RANDOM % max_index) + 1 ))"
    secret_share "$rand"

    p_data_0+=("$(patient_pref $share_0)")
    p_data_1+=("$(patient_pref $share_1)")
    p_data_2+=("$(patient_pref $share_2)")
done

for _ in $(seq "$1"); do
    rand="$(( (RANDOM % max_index) + 1 ))"
    secret_share "$rand"

    t_data_0+=("$(therapist_pref $share_0)")
    t_data_1+=("$(therapist_pref $share_1)")
    t_data_2+=("$(therapist_pref $share_2)")
done

for i in $(seq 0 2); do
    eval 'echo "${p_data_'$i'[*]} ${t_data_'$i'[*]}" > MP-SPDZ/Player-Data/Input-P'$i'-0'
done
