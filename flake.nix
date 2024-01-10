{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";

  # Some dependencies of this flake are not yet available on non linux systems
  inputs.systems.url = "github:nix-systems/x86_64-linux";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.systems.follows = "systems";

  inputs.cmake-nix-hello-world.url = github:samularity/cmake-nix-hello-world/32bit;
  inputs.cmake-nix-hello-world.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, nixos-hardware, cmake-nix-hello-world, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        packages.default = packages.sd-image;
        packages.sd-image = (import "${nixpkgs}/nixos" {
          configuration =
            { config, pkgs, ... }: {
              imports = [
                "${nixos-hardware}/starfive/visionfive/v2/sd-image-installer.nix"
              ];

                #use "own" kernel
                boot.kernelPackages = (pkgs.callPackage ./linux-6.6.nix {
                  inherit (config.boot) kernelPatches;
                });

              # set password for ssh login
              users.users.nixos.password = "nixos";

              # AND configure networking
              networking.interfaces.end0.useDHCP = true;
              networking.interfaces.end1.useDHCP = true;

              networking.firewall = {
                enable = true;
                allowedTCPPorts = [ 23 50000 52000 ];
                allowedUDPPorts = [ 50000 50001 ];
                allowedUDPPortRanges = [
                  { from = 19997; to = 19999; }
                ];
              };

              sdImage.compressImage = true;

              nixpkgs.crossSystem = {
                config = "riscv64-unknown-linux-gnu";
                system = "riscv64-linux";
              };

              hardware.deviceTree.overlays = [{
                name = "8GB-patch";
                dtsFile = "${nixos-hardware}/starfive/visionfive/v2/8gb-patch.dts";
              }];

              environment.systemPackages = with pkgs; [
                wget
                htop
                python3
                file
                cmake-nix-hello-world.packages.${config.nixpkgs.crossSystem.system}.default
                #(callPackage ./cmake/package.nix {} ) # use for loacal package
              ];


              system.stateVersion = "23.05";
            };
          inherit system;
        }).config.system.build.sdImage;
      });
}
