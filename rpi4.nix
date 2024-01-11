{ config, pkgs, nixos-hardware, nixpkgs,  ... }: {
    imports = [
    nixos-hardware.nixosModules.raspberrry-pi-4
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    ];



    hardware = {
        raspberry-pi."4".apply-overlays-dtmerge.enable = true;
        deviceTree = {
        enable = true;
        filter = "*rpi-4-*.dtb";
        };
    };
    
    environment.systemPackages = with pkgs; [
        libraspberrypi
        raspberrypi-eeprom
    ];

    sdImage.compressImage = true;

    nixpkgs.crossSystem.system = "aarch64-linux";
    nixpkgs.localSystem.config = "x86_64-unknown-linux-gnu";



}