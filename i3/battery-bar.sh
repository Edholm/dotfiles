#!/bin/bash
status=$(acpi -b | cut -d\  -f 3 | cut -d, -f1)
case $status in
    "Charging") echo -n "⌁ ";;
    "Discharging") echo -n "◯ " ;;
    *)  echo -n "● ";;
esac
perc=$(acpi -b | cut -d\  -f4 | cut -d% -f1)
print-bar $perc
