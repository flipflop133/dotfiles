#!/bin/bash
# Script to enable or disable some power saving features on the lenovo Ideapad 5
# Tool used to find right settings: powertop & TLP
# Tool to control the lenovo fan: thinkfan
# References:
# 	https://wiki.archlinux.org/index.php/Power_management#Power_saving
#	https://wiki.archlinux.org/index.php/Laptop#Power_management
#	https://wiki.archlinux.org/index.php/CPU_frequency_scaling

power_save_mode(){
	#####################
	# Disable bluetooth #
	#####################
	rmmod btusb
	rfkill block bluetooth

	#######
	# CPU #
	#######
	echo 1000000 > tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
	echo powersave > tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

	#################
	# INTEL P-STATE #
	#################
	# disable turbo boost
	echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

	# set min_perf_pct to 8 (lowest possible value)
	echo 8 > /sys/devices/system/cpu/intel_pstate/min_perf_pct

	# set max_perf_pct to 8
	echo 20 > /sys/devices/system/cpu/intel_pstate/max_perf_pct

	#######
	# GPU #
	#######
	echo 100 > /sys/class/drm/card0/gt_max_freq_mhz
	echo 100 > /sys/class/drm/card0/gt_boost_freq_mhz

	#########
	# Audio #
	#########
	echo 1 > /sys/module/snd_hda_intel/parameters/power_save
	echo 1 > /sys/module/snd_hda_intel/parameters/power_save_controller

	#############################
	# Ideapad specific settings #
	#############################
	echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/usb_charging
	echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/camera_power
	echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode

	#########
	# other #
	#########
	# set HWP(intel HardWare P-state) to power
	echo power > /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy1/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy2/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy3/energy_performance_preference

	# efficient workqueues
	echo Y > /sys/module/workqueue/parameters/power_efficient

	#####################
	# powertop commands #
	#####################
	# Wireless power saving for interface wlan0
	iw dev wlan0 set power_save on

	# WM writeback timeout
	echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs';

	# Enable SATA link power management for host0
	echo 'med_power_with_dipm' > '/sys/class/scsi_host/host0/link_power_management_policy';

	# Enable Audio codec power management
	echo '1' > '/sys/module/snd_hda_intel/parameters/power_save';

	# NMI watchdog
	echo '0' > '/proc/sys/kernel/nmi_watchdog';

	# Runtime PM for I2C Adapter
	echo 'auto' > '/sys/bus/i2c/devices/i2c-7/device/power/control';
	echo 'auto' > '/sys/bus/i2c/devices/i2c-14/device/power/control';

	# Autosuspend for USB device Goodix FingerPrint Device
	echo 'auto' > '/sys/bus/usb/devices/3-7/power/control';

	# PCI devices
	echo 'auto' > '/sys/bus/pci/devices/0000:00:14.3/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:04.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:01:00.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.5/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:14.2/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:0a.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/ata1/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control';
	echo -e "\e[29mPower Save mode applied!\e[0m"
}
balanced_mode(){
	#####################
	# Disable bluetooth #
	#####################
	rmmod btusb
	rfkill block bluetooth

	#####################
	# cpupower commands #
	#####################
	cpupower idle-set -E
	cpupower set --perf-bias 15
	cpupower frequency-set -u 1.4GHz
	cpupower frequency-set -g powersave

	#################
	# INTEL P-STATE #
	#################
	# disable turbo boost
	echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

	# set min_perf_pct to 8 (lowest possible value)
	echo 8 > /sys/devices/system/cpu/intel_pstate/min_perf_pct

	# set max_perf_pct to 8
	echo 20 > /sys/devices/system/cpu/intel_pstate/max_perf_pct

	#######
	# GPU #
	#######
	echo 450 > /sys/class/drm/card0/gt_max_freq_mhz
	echo 450 > /sys/class/drm/card0/gt_boost_freq_mhz

	#########
	# Audio #
	#########
	echo 1 > /sys/module/snd_hda_intel/parameters/power_save
	echo 1 > /sys/module/snd_hda_intel/parameters/power_save_controller

	#############################
	# Ideapad specific settings #
	#############################
	echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/usb_charging
	echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/camera_power
	echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode

	#########
	# other #
	#########
	# set HWP(intel HardWare P-state) to power
	echo power > /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy1/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy2/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy3/energy_performance_preference

	# efficient workqueues
	echo Y > /sys/module/workqueue/parameters/power_efficient

	#####################
	# powertop commands #
	#####################
	# VM writeback timeout
	echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs';

	# Enable SATA link power management for host0
	echo 'med_power_with_dipm' > '/sys/class/scsi_host/host0/link_power_management_policy';

	# Enable Audio codec power management
	echo '1' > '/sys/module/snd_hda_intel/parameters/power_save';

	# NMI watchdog
	echo '0' > '/proc/sys/kernel/nmi_watchdog';

	# Runtime PM for I2C Adapter
	echo 'auto' > '/sys/bus/i2c/devices/i2c-7/device/power/control';

	# Autosuspend for USB device Goodix FingerPrint Device
	echo 'auto' > '/sys/bus/usb/devices/3-7/power/control';

	# PCI devices
	echo 'auto' > '/sys/bus/pci/devices/0000:00:14.3/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:04.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:01:00.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.5/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:14.2/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:0a.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/ata1/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control';
	echo -e "\e[29mBalanced mode applied!\e[0m"
}

boost_mode(){
	#####################
	# Disable bluetooth #
	#####################
	rmmod btusb
	rfkill block bluetooth

	#####################
	# cpupower commands #
	#####################
	cpupower idle-set -E
	cpupower set --perf-bias 15
	cpupower frequency-set -u 2.8GHz
	cpupower frequency-set -g powersave

	#################
	# INTEL P-STATE #
	#################
	# disable turbo boost
	echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

	# set min_perf_pct to 8 (lowest possible value)
	echo 8 > /sys/devices/system/cpu/intel_pstate/min_perf_pct

	# set max_perf_pct to 8
	echo 20 > /sys/devices/system/cpu/intel_pstate/max_perf_pct

	#######
	# GPU #
	#######
	echo 900 > /sys/class/drm/card0/gt_max_freq_mhz
	echo 900 > /sys/class/drm/card0/gt_boost_freq_mhz

	#########
	# Audio #
	#########
	echo 1 > /sys/module/snd_hda_intel/parameters/power_save
	echo 1 > /sys/module/snd_hda_intel/parameters/power_save_controller

	#############################
	# Ideapad specific settings #
	#############################
	echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/usb_charging
	echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/camera_power
	echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode

	#########
	# other #
	#########
	# set HWP(intel HardWare P-state) to power
	echo power > /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy1/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy2/energy_performance_preference
	echo power > /sys/devices/system/cpu/cpufreq/policy3/energy_performance_preference

	# efficient workqueues
	echo Y > /sys/module/workqueue/parameters/power_efficient

	#####################
	# powertop commands #
	#####################
	# VM writeback timeout
	echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs';

	# Enable SATA link power management for host0
	echo 'med_power_with_dipm' > '/sys/class/scsi_host/host0/link_power_management_policy';

	# Enable Audio codec power management
	echo '1' > '/sys/module/snd_hda_intel/parameters/power_save';

	# NMI watchdog
	echo '0' > '/proc/sys/kernel/nmi_watchdog';

	# Runtime PM for I2C Adapter
	echo 'auto' > '/sys/bus/i2c/devices/i2c-7/device/power/control';

	# Autosuspend for USB device Goodix FingerPrint Device
	echo 'auto' > '/sys/bus/usb/devices/3-7/power/control';

	# PCI devices
	echo 'auto' > '/sys/bus/pci/devices/0000:00:14.3/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:04.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:01:00.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.5/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:14.2/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:0a.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:17.0/ata1/power/control';
	echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control';
	echo -e "\e[29mBoost mode applied!\e[0m"
}
main(){
	# check for root rights
	if [ $(id -u) -eq 0 ]
	then
		if [ -z "$1" ];then
			echo -e "\e[96mPower MANAGER SCRIPT\e[0m"
			echo ''
			echo -e "\e[96m1)Power Save Mode\e[0m"
			echo -e "\e[96m2)Balanced Mode\e[0m"
			echo -e "\e[96m2)Boost Mode\e[0m"
			read -r -p "Enter a selection:" response
			if [ "$response" == "1" ]; then
				power_save_mode
			elif [ "$response" == "2" ]; then
				balanced_mode
			elif [ "$response" == "3" ]; then
				boost_mode
			else
				clear
				echo -e "\e[31mPlease enter a valid value\e[0m"
				main
			fi
		else
			$1
		fi
	else
		echo -e "\e[31mPlease run script as root.\e[0m"
		exit
	fi
}
clear
main "$1"
