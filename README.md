# BlackShark SHARK KLE-H0 TWRP Device Tree

## Device Overview
This repository contains the device tree for the BlackShark SHARK KLE-H0, enabling the build of Orangefox Recovery for this device.

### Device Specifications
- **Device Name**: BlackShark SHARK KLE-H0
- **Brand**: BlackShark
- **Manufacturer**: BlackShark
- **Model**: KLE-H0
- **Architecture**: arm64
- **Screen Resolution**: 1080 x 2400
- **Screen Density**: 440 dpi
- **Recovery Image Source**: KLEN2108271OS00MR0/V11.0.4.0.JOYUI

## Sources
This device tree is based on the following sources:
- **TWRPGen**: Utilized for generating the initial device tree structure.
- **OrangeFox**: Compatibility with the OrangeFox recovery project.

## Versioning
- **TWRP Version**: 11.0
- **Android Version**: 11
- **Build Type**: Testing

## Changes Made
To ensure the device tree is buildable, the following changes have been implemented:
1. **Updated Inheritance Paths**: Corrected paths in `twrp_klein.mk` to ensure all necessary files are included.
2. **Added Prebuilt Kernel Support**: Configured `BoardConfig.mk` to support prebuilt kernels and device tree blobs.
3. **Fixed Dependencies**: Ensured all required packages are included in `device.mk` for proper functionality.
4. **Screen Dimensions**: Set appropriate screen width and height in `BoardConfig.mk` to match the device specifications.

## Credits
- **TWRPGen**: For generating the initial device tree structure.
- **OrangeFox**: For their recovery project and support.

## License
This project is licensed under the Apache License 2.0.
