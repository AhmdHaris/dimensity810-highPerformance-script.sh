#!/bin/bash

red='\e[31m'
reset='\e[0m'

function print_warning {
    echo "${red}  [ ! ] $1${reset}"
}

clear
sleep 1

echo "[ ~ ] Enable High Performance for Dimensity 810 "
echo
sleep 1
echo "[ - ] If you find an error, please report it in Issue"
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

# PPM
    echo PPM :
	echo 1 > /proc/ppm/enabled
	echo 0 1 > /proc/ppm/policy_status
	echo 1 1 > /proc/ppm/policy_status
	echo 2 1 > /proc/ppm/policy_status
	echo 3 1 > /proc/ppm/policy_status
	echo 4 1 > /proc/ppm/policy_status
	echo 5 1 > /proc/ppm/policy_status
	echo 6 1 > /proc/ppm/policy_status
	echo 7 1 > /proc/ppm/policy_status
	echo 8 0 > /proc/ppm/policy_status
	echo 9 1 > /proc/ppm/policy_status
	cat /proc/ppm/policy_status
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

sleep 1
echo
# Set CPU mode
echo "Setting CPU mode..."
echo 3 > /proc/cpufreq/cpufreq_power_mode
echo 1 > /proc/cpufreq/cpufreq_cci_mode
sleep 1
# Display current modes
echo "CPU Power mode: $(cat /proc/cpufreq/cpufreq_power_mode)"
echo "CPU CCI mode: $(cat /proc/cpufreq/cpufreq_cci_mode)"
echo

# Function to set GPU frequency
set_gpu_freq() {
  frequency="$1"
  echo "$frequency" > /proc/gpufreq/gpufreq_opp_freq
}

sleep 1
# Set GPU frequency to 1068000
echo "Locking GPU frequency to 1068000 MHz"
set_gpu_freq 1068000

sleep 1
# Verify GPU frequency
echo "Current GPU frequency: $(cat /proc/gpufreq/gpufreq_opp_freq | cut -d, -f1) MHz"

# Function to set CPU performance mode
set_cpu_perf() {
  mode="$1"
  echo "$mode" > /sys/devices/system/cpu/perf/enable
}
sleep 1
# Enable CPU performance mode
echo "Enabling CPU performance mode..."
set_cpu_perf 1

# Verify CPU performance mode
echo "CPU performance mode: $(cat /sys/devices/system/cpu/perf/enable)"
echo

# Function to set GPU power policy
set_gpu_power_policy() {
  policy="$1"
  echo "$policy" > /sys/devices/platform/13000000.mali/power_policy
}

sleep 1
# Set GPU power policy to always_on
echo "Setting GPU power policy to always_on"
set_gpu_power_policy always_on

sleep 1
# Verify GPU power policy
echo "GPU power policy: $(cat /sys/devices/platform/13000000.mali/power_policy)"
echo

# Logcat
echo Force stop logcat to reduce CPU hogging
stop logd
echo

# Disable some debugging
echo 0 > /sys/kernel/ccci/debug

# Function to set CPU frequency
set_cpu_freq_limits() {
    cluster="$1"
    freq="$2"
    echo "$cluster $freq" > /proc/ppm/policy/hard_userlimit_max_cpu_freq
    echo "$cluster $freq" > /proc/ppm/policy/hard_userlimit_min_cpu_freq
}

# Set big cluster frequency to 2400MHz
echo "Locking big cluster to 2400MHz"
set_cpu_freq_limits 1 2400000

# Set little cluster frequency to 2000MHz
echo "Locking little cluster to 2000MHz"
set_cpu_freq_limits 0 2000000

# Function to set APUs frequency
set_apus_freq() {
  value="$1"
  echo "$value" > /sys/module/mmdvfs_pmqos/parameters/force_step
}

sleep 1
# Set APUs frequency to 1
echo "Setting APUs frequency to 1"
set_apus_freq 1

sleep 1
# Verify APUs frequency
echo "APUs frequency: $(cat /sys/module/mmdvfs_pmqos/parameters/force_step)"
echo

# Function to set TCP congestion control
set_tcp_congestion_control() {
    algo="$1"
    echo "$algo" > /proc/sys/net/ipv4/tcp_congestion_control
}

sleep 1
# Set TCP congestion control to bic
echo "Setting TCP congestion control to bic"
set_tcp_congestion_control bic

sleep 1
# Enable TCP low latency
echo "Enabling TCP low latency"
echo 1 > /proc/sys/net/ipv4/tcp_low_latency
echo 3 > /proc/sys/net/ipv4/tcp_fastopen

sleep 1
# Verify TCP congestion control
echo "TCP congestion control: $(cat /proc/sys/net/ipv4/tcp_congestion_control)"
echo "TCP Fastopen: $(/proc/sys/net/ipv4/tcp_fastopen)"
