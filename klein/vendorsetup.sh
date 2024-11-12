#!/bin/bash

# OrangeFox build variables for Black Shark 3 (klein)

# Device Information
export FOX_BUILD_DEVICE="klein"
export OF_MAINTAINER="CaullenOmdahl"  # Replace with your name
export FOX_VERSION="R11.1"

# Target Architecture
export TARGET_ARCH=arm64

# A/B Device Configuration
export OF_AB_DEVICE=1
# Uncomment if your device uses virtual A/B partitions
# export OF_VIRTUAL_AB_DEVICE=1

# File System Encryption
export OF_KEEP_FORCED_ENCRYPTION=1
export OF_KEEP_DM_VERITY=1
export OF_DONT_PATCH_ENCRYPTED_DEVICE=1

# MagiskBoot Settings
export OF_USE_MAGISKBOOT=1
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
export OF_FORCE_MAGISKBOOT_BOOT_PATCH_MIUI=1

# Screen and Display Settings
export OF_SCREEN_H=2400
export OF_STATUS_H=80
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_HIDE_NOTCH=0
export TARGET_SCREEN_WIDTH=1080
export TARGET_SCREEN_HEIGHT=2400
export OF_ALLOW_DISABLE_NAVBAR=0

# Compression and Binary Settings
export OF_USE_LZMA_COMPRESSION=1
export FOX_USE_BASH_SHELL=1
export FOX_ASH_IS_BASH=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_XZ_UTILS=1
export FOX_USE_GREP_BINARY=1

# Advanced Features
export OF_SKIP_FBE_DECRYPTION=1
export OF_SKIP_MULTIUSER_FOLDERS_BACKUP=1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
export OF_CHECK_OVERWRITE_ATTEMPTS=1

# OTA and MIUI Settings
export OF_NO_MIUI_OTA_VENDOR_BACKUP=1
export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1
export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=0
export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1

# Quick Backup List
export OF_QUICK_BACKUP_LIST="/boot;/data;/system_image;/vendor_image;"

# Miscellaneous
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL="C"

# Build Type
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1

# Build Variant (optional)
# export FOX_VARIANT="MIUI"

# Include OrangeFox Recovery configurations
source $FOX_BUILD_DEVICE/device.mk
