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
sleep 1
print_warning "Please Execute The Script With Root Permission!"
sleep 1
echo 
echo "[ - ] If you find an error, please report it in Issue"
sleep 1
echo

echo "Enabling GED Modules for Mediatek Dimensity..."
sleep 1
echo
# Function to set GED module parameter
set_ged_param() {
  echo "$1" > "/sys/module/ged/parameters/$2"
}

# GED Modules
set_ged_param 1 gx_game_mode
set_ged_param 1 gx_force_cpu_boost
set_ged_param 1 boost_amp
set_ged_param 1 boost_extra
set_ged_param 1 boost_gpu_enable
set_ged_param 1 enable_cpu_boost
set_ged_param 1 enable_gpu_boost
set_ged_param 1 enable_game_self_frc_detect
set_ged_param 10 gpu_idle
set_ged_param 100 cpu_boost_policy
set_ged_param 0 ged_force_mdp_enable
set_ged_param 1 ged_boost_enable
set_ged_param 100 ged_smart_boost
set_ged_param 1 gx_frc_mode
set_ged_param 1 gx_boost_on

echo "GED Modules enabled"
sleep 1
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
echo "Checking governor schedule..."
echo "core 0-5: $(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor)"
echo
sleep 1
echo "core 6-7: $(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor)"
