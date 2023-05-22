STM8-SDCC-Template
=================

This repository contains a simple template project for STM8 development with SDCC. It is intended to be used as a starting point for new projects. It contains a simple blinky example and a build script for Linux and Windows.
This template is based on the [STM8-SPL-SDCC](https://github.com/bschwand/STM8-SPL-SDCC) repository, and we are very grateful to them.

LICENSE
=================

The original licenses remain, these sources are useable under the terms of [SLA044](http://www.st.com/SLA0044).

Toolchain Installation for SDCC
=================

  - if required, download and install [SDCC](http://sdcc.sourceforge.net/) and Gnu-Make. Add binaries to $(PATH)
  - for STM8 programming via SWIM debug interface
    - install libusb-dev (e.g. `sudo apt-get install libusb-1.0-0-dev`)
    - download and make [stm8flash](https://github.com/vdudouyt/stm8flash) source code
    - on Linux grant write access to ST-Link debugger by creating a file `/etc/udev/rules.d/99-stlinkv2.rules` with content  
    `SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", MODE="0666"`  
    Note: since several versions of ST-Link exist, check the idProduct of your device via command `usb-devices`
  - for STM8 programming via serial bootloader
    - download and make [stm8gal](https://github.com/gicking/stm8gal) source code
  - if necessary, set execute permission for build scripts in project folders

### Notes

  - on Windows
    - SWIM upload can also be performed via [STVisualProgrammer](http://www.st.com). Please adapt build scripts accordingly
    - bootloader upload can also be performed via [Flash Loader Demonstrator](http://www.st.com). However, this is not supported by the automatic build