# Inherit from OrangeFox base product
$(call inherit-product, vendor/recovery/omni_device.mk)

# Inherit from the device-specific makefile
$(call inherit-product, device/blackshark/klein/device.mk)

PRODUCT_DEVICE := klein
PRODUCT_NAME := omni_klein
PRODUCT_BRAND := BlackShark
PRODUCT_MODEL := BlackShark 3
PRODUCT_MANUFACTURER := BlackShark

# Build Description
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="KLE-H0-user 11 KLEN2108271OS00MR0 V11.0.4.0.JOYUI release-keys"

# Fingerprint
BUILD_FINGERPRINT := BlackShark/KLE-H0/klein:11/KLEN2108271OS00MR0/V11.0.4.0.JOYUI:user/release-keys
