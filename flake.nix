{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";

  # Some dependencies of this flake are not yet available on non linux systems
  inputs.systems.url = "github:nix-systems/x86_64-linux";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.systems.follows = "systems";

  outputs = { self, nixpkgs, nixos-hardware, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        packages.default = packages.sd-image;
        packages.sd-image = (import "${nixpkgs}/nixos" {
          configuration =
            { config, pkgs, ... }: {
              imports = [
                "./linux-6.6.nix"
                "${nixos-hardware}/starfive/visionfive/v2/sd-image-installer.nix"
              ];


              users.users.sam = {
                isNormalUser = true;
                description = "sam";
                extraGroups = [ "networkmanager" "wheel" "dialout" ];
              };

           

              # If you want to use ssh set a password
              users.users.sam.password = "1234";
              # OR add your public ssh key
              # users.users.nixos.openssh.authorizedKeys.keys = [ "ssh-rsa ..." ];

              # AND configure networking
              networking.interfaces.end0.useDHCP = true;
              networking.interfaces.end1.useDHCP = true;

              # Additional configuration goes here

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
              ];


              system.stateVersion = "23.05";
            };
          inherit system;
        }).config.system.build.sdImage;
      });
}
