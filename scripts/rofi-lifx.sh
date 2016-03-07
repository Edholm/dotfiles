#!/usr/bin/env bash
# Control your lifx bulbs with lifx-cli and rofi

declare -A actions
actions["toggle"]="lifx toggle"
actions["on"]="lifx on"
actions["off"]="lifx off"

function print_actions() {
    for a in ${!actions[*]}; do
        echo $a
    done
}

function start_rofi() {
    print_actions | rofi -dmenu -p "lifx: "
}

choosen=$(start_rofi)

if [ ! -z "${choosen}" ]; then
    ${actions[${choosen}]}
fi
