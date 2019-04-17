#!/usr/bin/env bash

# This is adapted from Skia's recipe at:
# https://github.com/google/skia/blob/e25b4472cdd9f09cd393c9c34651218507c9847b/infra/bots/recipe_modules/flavor/android.py
#
# Use that recipe to modify this for your test device. This shell script assumes Nexus 5.
# Every device will have slightly different numbers and processes.

set -e

# Remove whitespace characters from string.
# From https://stackoverflow.com/a/3352015/1416886
trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

TARGET_DEVICE="Nexus 5"
echo "This assumes a rooted ${TARGET_DEVICE} attached via USB."
ACTUAL_DEVICE=`adb shell getprop ro.product.model`
ACTUAL_DEVICE=`trim ${ACTUAL_DEVICE}`
echo "${ACTUAL_DEVICE} detected."

if [[ "${TARGET_DEVICE}" != "${ACTUAL_DEVICE}" ]]; then
    echo "Error: the attached device ${ACTUAL_DEVICE} is not ${TARGET_DEVICE}."
    echo "Aborting. If you have another device attached, unplug it."
    exit 1
fi

# Nexus 5 has only one CPU to scale, cpu0.
# https://github.com/google/skia/blob/e25b4472cdd9f09cd393c9c34651218507c9847b/infra/bots/recipe_modules/flavor/android.py#L53
CPU_NO="0"

# Root path to CPU scaling virtual files.
# https://github.com/google/skia/blob/e25b4472cdd9f09cd393c9c34651218507c9847b/infra/bots/recipe_modules/flavor/android.py#L283
ROOT="/sys/devices/system/cpu/cpu${CPU_NO}/cpufreq"

echo
ACTUAL_CPU_FREQ=`adb shell "cat ${ROOT}/scaling_cur_freq"`
echo "Current CPU frequency: ${ACTUAL_CPU_FREQ}"
ACTUAL_GOV=`adb shell "cat /sys/devices/system/cpu/cpu${CPU_NO}/cpufreq/scaling_governor"`
echo "Current governor: ${ACTUAL_GOV}"
echo

echo "This script will set frequencies of your device's CPU and GPU."
echo; read -n 1 -s -r -p "Press any key to continue, or Ctrl-C to cancel"; echo

# https://github.com/google/skia/blob/e25b4472cdd9f09cd393c9c34651218507c9847b/infra/bots/recipe_modules/flavor/android.py#L151
GPU_FREQ="320000000"
IDLE_TIMER="10000"

adb root

# --- CPU ---

# Set userspace governor for cpu0
# https://github.com/google/skia/blob/e25b4472cdd9f09cd393c9c34651218507c9847b/infra/bots/recipe_modules/flavor/android.py#L205
GOV="userspace"
echo "Setting CPU governor to: ${GOV}"
adb shell "echo ${GOV} > /sys/devices/system/cpu/cpu${CPU_NO}/cpufreq/scaling_governor"
ACTUAL_GOV=`adb shell "cat /sys/devices/system/cpu/cpu${CPU_NO}/cpufreq/scaling_governor"`
echo "               - actual: ${ACTUAL_GOV}"


# If you want to check available frequencies:
#   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
#
# Since we are hardcoding this script for Nexus 5, we can just select the frequency we want.
#
# Nexus 5 max frequency: 2,265,600 Hz
#                  60% : 1,359,360 Hz
#     closest available: 1,267,200 Hz
CPU_FREQ="1267200"
MAX_FREQ="2265600"

echo "Setting CPU frequency to: ${CPU_FREQ}"
# https://github.com/google/skia/blob/e25b4472cdd9f09cd393c9c34651218507c9847b/infra/bots/recipe_modules/flavor/android.py#L326
# If scaling_max_freq is lower than our attempted setting, it won't take.
# We must set min first, because if we try to set max to be less than min
# (which sometimes happens after certain devices reboot) it returns a
# perplexing permissions error.
adb shell "echo 0 > ${ROOT}/scaling_min_freq"
adb shell "echo ${CPU_FREQ} > ${ROOT}/scaling_max_freq"
adb shell "echo ${CPU_FREQ} > ${ROOT}/scaling_setspeed"
sleep 5
ACTUAL_CPU_FREQ=`adb shell "cat ${ROOT}/scaling_cur_freq"`
echo "                - actual: ${ACTUAL_CPU_FREQ}"

# According to Skia, no need to disable CPUs on a Nexus 5.
# https://github.com/google/skia/blob/e25b4472cdd9f09cd393c9c34651218507c9847b/infra/bots/recipe_modules/flavor/android.py#L145
# But actually, Nexus 5 does scale other CPUs.

CPU_ONLINE=0
for n in 1 2 3
do
    echo "Turning CPU ${n} to: ${CPU_ONLINE}"
    adb shell "echo ${CPU_ONLINE} > /sys/devices/system/cpu/cpu${n}/online"
    ACTUAL=`adb shell "cat /sys/devices/system/cpu/cpu${n}/online"`
    echo "        - actual: ${ACTUAL}"
done


# --- GPU ---

# https://github.com/google/skia/blob/e25b4472cdd9f09cd393c9c34651218507c9847b/infra/bots/recipe_modules/flavor/android.py#L153
echo "Stopping thermald"
adb shell "stop thermald"

echo "Setting GPU frequency to: ${GPU_FREQ}"
adb shell "echo ${GPU_FREQ} > /sys/class/kgsl/kgsl-3d0/gpuclk"
ACTUAL_GPU_FREQ=`adb shell "cat /sys/class/kgsl/kgsl-3d0/gpuclk"`
echo "                - actual: ${ACTUAL_GPU_FREQ}"

echo "Setting GPU idle timer to: ${IDLE_TIMER}"
adb shell "echo ${IDLE_TIMER} > /sys/class/kgsl/kgsl-3d0/idle_timer"
ACTUAL_TIMER=`adb shell "cat /sys/class/kgsl/kgsl-3d0/idle_timer"`
echo "                 - actual: ${ACTUAL_TIMER}"

echo "Setting force_bus_on, force_rail_on, force_clk_on"
adb shell "echo 1 > /sys/class/kgsl/kgsl-3d0/force_bus_on"
adb shell "echo 1 > /sys/class/kgsl/kgsl-3d0/force_rail_on"
adb shell "echo 1 > /sys/class/kgsl/kgsl-3d0/force_clk_on"
