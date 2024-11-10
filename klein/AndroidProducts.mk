#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/omni_klein.mk

COMMON_LUNCH_CHOICES := \
    omni_klein-user \
    omni_klein-userdebug \
    omni_klein-eng

   PRODUCT_NAME := omni_klein
   PRODUCT_DEVICE := klein
   PRODUCT_BRAND := blackshark
   PRODUCT_MODEL := KLE-H0