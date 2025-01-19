# nix-config
Personal NixOS configuration

## Installation

### Overview

1. Create password file with the LUKS encryption password -> `/tmp/secret.key'.
1. Partition the device with disko.
1. Run nixos installation with existing config.

## Virtual machine development

### Libvirt (VMM)

1. Create new virtual machine
1. Select ISO
1. 4Gb RAM - 4 vCPU - 120 GB Diskspace
1. Customize VM before installation
1. Overview -> Firmware: `UEFI ... OVMF_CODE.fd` -> Apply
1. Display Spice -> Listen type: `None` -> OpenGL: `Auto` -> Apply
1. Video QXL -> Model: `VirtIO` -> 3D Acceleration `On` -> Apply
1. Begin Installation
