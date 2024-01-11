# NixOS babysteps in CrossCompiling / image 

my try to get an easy (cross) image builder with nixos

## Supported Boards

### VisionFive 2

#### Build
```bash
nix build .#visionfive2-sdcard
```


### RaspberryPi 4

#### Build
```bash
nix build .#rpi4-sdcard
```


## other things to keep an eye on:

#### NickCao's RISC-V port
[NickCao/nixos-riscv](https://github.com/NickCao/nixos-riscv/)

#### official visionfive nixos-hw repo

[nixos-hardware/starfive/visionfive/v2](https://github.com/NixOS/nixos-hardware/tree/master/starfive/visionfive/v2)

#### easy to add sd-images
[nixpkg/nixos/modules/installer/sd-card](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/installer/sd-card)