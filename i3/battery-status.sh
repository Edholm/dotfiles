#!/bin/bash
status=$(acpi -b | cut -d\  -f 3 | cut -d, -f1)
case $status in
    "Charging") echo ⌁ ;;
    "Discharging") echo ◯ ;;
    *)  echo ● ;;
esac
