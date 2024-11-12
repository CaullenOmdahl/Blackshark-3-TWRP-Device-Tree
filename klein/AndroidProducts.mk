#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/twrp_klein.mk

COMMON_LUNCH_CHOICES := \
    twrp_klein-eng \
    twrp_klein-userdebug \
    twrp_klein-user

   PRODUCT_NAME := twrp_klein
   PRODUCT_DEVICE := klein
   PRODUCT_BRAND := blackshark
   PRODUCT_MODEL := KLE-H0