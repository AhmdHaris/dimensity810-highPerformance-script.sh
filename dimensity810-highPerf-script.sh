#!/bin/bash

red='\e[31m'
reset='\e[0m'

function print_warning() {
    echo "${red}  [ ! ] $1${reset}"
}

function set_ged_param() {
    echo "$1" > "/sys/module/ged/parameters/$2"
}

function set_governor() {
    governor="$1"
    echo "Setting CPU governor to $governor for cores 0 - 6 (little core)..."
    echo "$governor" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
    echo "Setting CPU governor to $governor for cores 7 and 8 (big core)...."
    echo "$governor" > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
}

function set_cpu_mode() {
    echo "Setting CPU mode..."
    echo 3 > /proc/cpufreq/cpufreq_power_mode
    echo 1 > /proc/cpufreq/cpufreq_cci_mode
}

function set_gpu_freq() {
    frequency="$1"
    echo "$frequency" > /proc/gpufreq/gpufreq_opp_freq
}

function set_cpu_perf() {
    mode="$1"
    echo "$mode" > /sys/devices/system/cpu/perf/enable
}

function set_gpu_power_policy() {
    policy="$1"
    echo "$policy" > /sys/devices/platform/13000000.mali/power_policy
}

function set_cpu_freq_limits() {
    cluster="$1"
    freq="$2"
    echo "$cluster $freq" > /proc/ppm/policy/hard_userlimit_max_cpu_freq
    echo "$cluster $freq" > /proc/ppm/policy/hard_userlimit_min_cpu_freq
}

function set_apus_freq() {
    value="$1"
    echo "$value" > /sys/module/mmdvfs_pmqos/parameters/force_step
}

function set_tcp_congestion_control() {
    algo="$1"
    echo "$algo" > /proc/sys/net/ipv4/tcp_congestion_control
}

clear
sleep 1

print_warning "Warning! This script will give best performance experience & your battery will drain faster and your phone might be heating up unforeseen consequences"
print_warning "Please Do With Your Own Risk !"
print_warning "Please Execute The Script With Root Permission!"

echo "Enabling GED Modules for Mediatek Dimensity..."
set_ged_param 1 gx_game_mode
# ... other GED parameters ...

echo "Setting CPU governor to performance..."
set_governor performance

echo "Setting CPU mode..."
set_cpu_mode

echo "Locking GPU frequency to 1068000 MHz"
set_gpu_freq 1068000

echo "Enabling CPU performance mode..."
set_cpu_perf 1

echo "Setting GPU power policy to always_on"
set_gpu_power_policy always_on

echo "Locking big cluster to 2400MHz"
set_cpu_freq_limits 1 2400000

echo "Locking little cluster to 2000MHz"
set_cpu_freq_limits 0 2000000

echo "Setting APUs frequency to 1"
set_apus_freq 1

echo "Setting TCP congestion control to bic"
set_tcp_congestion_control bic

echo "Enabling TCP low latency"
echo 1 > /proc/sys/net/ipv4/tcp_low_latency
echo 3 > /proc/sys/net/ipv4/tcp_fastopen

echo "Force stop logcat to reduce CPU hogging"
stop logd

echo "Force stop logcat to reduce CPU hogging"
stop thermal
stop thermalloadalgod

echo "Disable some debugging"
echo 0 > /sys/kernel/ccci/debug
