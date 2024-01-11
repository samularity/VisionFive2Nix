{ config, pkgs, nixos-hardware, ... }: {
    imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
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

    boot.kernelParams = [
        "console=ttyS0,115200n8"
        "console=tty1"
    ];

    nixpkgs.crossSystem.system = "aarch64-linux";
    nixpkgs.localSystem.config = "x86_64-unknown-linux-gnu";

    nixpkgs.overlays = [
        (final: super: {
            makeModulesClosure = x:
            super.makeModulesClosure (x // { allowMissing = true; });
    })];

}