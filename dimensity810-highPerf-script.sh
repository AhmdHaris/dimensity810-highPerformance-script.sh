#!/bin/bash

red='\e[31m'
reset='\e[0m'

function print_warning {
    echo "${red}  [ ! ] $1${reset}"
}

clear
sleep 1

echo " [ ~ ] Enable High Performance for Dimensity 810 "
sleep 1
print_warning "Warning! This script will give best performance experience & your battery will drain faster and your phone might be heating up unforeseen consequences"
echo
sleep 3
print_warning "Please Do With Your Own Risk !"
echo

# Function to set CPU governor
set_governor() {
  governor="$1"
  echo "Setting CPU governor to $governor for cores 0 - 6 (little core)..."
  echo "$governor" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
  sleep 1
  echo "Setting CPU governor to $governor for cores 7 and 8 (big core)...."
  echo "$governor" > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
}

# Set governor to performance
set_governor performance

# Verify governor settings
sleep 1
echo "Checking governor settings..."
echo "core 0-5: $(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor)"
sleep 1
echo "core 6-7: $(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor)"