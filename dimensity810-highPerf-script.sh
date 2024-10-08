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

function overvolt_core() {
  core_type="$1"
  offset="$2"

  echo "Overvolting $core_type with offset $offset"
  echo "$offset" > "/proc/eem/EEM_DET_$core_type/eem_offset"
  cat "/proc/eem/EEM_DET_$core_type/eem_offset"
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
set_ged_param 1 ged_smart_boost
set_ged_param 1 gx_frc_mode
set_ged_param 1 gx_boost_on

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

echo "Overvolting BIG Cores, LITTLE Cores, and CPU BUS"
overvolt_core B 50
overvolt_core L 50
overvolt_core CCI 50

echo "Setting APUs frequency to 1"
set_apus_freq 1

echo "Setting TCP congestion control to bic"
set_tcp_congestion_control bic

echo "Enabling TCP low latency"
echo 1 > /proc/sys/net/ipv4/tcp_low_latency
echo 3 > /proc/sys/net/ipv4/tcp_fastopen

echo "Force stop logcat to reduce CPU hogging"
stop logd

echo "Force stop thermal"
stop thermal
stop thermalloadalgod
stop thermal_manager
setprop init.svc.vendor.thermal-hal-2-0.mtk stopped
setprop debug.thermal.throttle.support no

echo "Disable some debugging"
echo 0 > /sys/kernel/ccci/debug

# Force Maximum DRAM Freq
echo 0 >/sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp
