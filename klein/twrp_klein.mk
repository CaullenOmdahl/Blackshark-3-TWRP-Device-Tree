#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Omni stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from klein device
$(call inherit-product, device/blackshark/klein/device.mk)

PRODUCT_DEVICE := klein
PRODUCT_NAME := twrp_klein
PRODUCT_BRAND := blackshark
PRODUCT_MODEL := SHARK KLE-H0
PRODUCT_MANUFACTURER := blackshark

PRODUCT_GMS_CLIENTID_BASE := android-blackshark

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="KLE-H0-user 11 KLEN2108271OS00MR0 V11.0.4.0.JOYUI release-keys"

BUILD_FINGERPRINT := blackshark/KLE-H0/klein:11/KLEN2108271OS00MR0/V11.0.4.0.JOYUI:user/release-keys
