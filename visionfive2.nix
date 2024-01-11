{ config, pkgs, nixos-hardware,  ... }: {
    imports = [
    "${nixos-hardware}/starfive/visionfive/v2/sd-image-installer.nix"
    ];

    #use "own" kernel
    boot.kernelPackages = (pkgs.callPackage ./linux-6.6.nix {
    inherit (config.boot) kernelPatches;
    });

    # AND configure networking
    networking.interfaces.end0.useDHCP = true;
    networking.interfaces.end1.useDHCP = true;

    sdImage.compressImage = true;

    nixpkgs.crossSystem = {
        config = "riscv64-unknown-linux-gnu";
        system = "riscv64-linux";
    };

  nixpkgs.localSystem.config = "x86_64-unknown-linux-gnu";


    hardware.deviceTree.overlays = [{
    name = "8GB-patch";
    dtsFile = "${nixos-hardware}/starfive/visionfive/v2/8gb-patch.dts";
    }];
}