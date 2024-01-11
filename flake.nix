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
        nixosConfigurations = {
          visionfive2 = nixpkgs.lib.nixosSystem {
            modules = [
              ./visionfive2.nix
              ./common.nix
              ];
              specialArgs = {inherit nixos-hardware cmake-nix-hello-world;};
            };

          rpi4 = nixpkgs.lib.nixosSystem {
            modules = [
              ./rpi4.nix
              ./common.nix
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"



              ];


              specialArgs = {inherit nixos-hardware cmake-nix-hello-world;};
            };

        };
    packages.visionfive2-sdcard = nixosConfigurations.visionfive2.config.system.build.sdImage;
    packages.rpi4-sdcard = nixosConfigurations.rpi4.config.system.build.sdImage;
    packages.default = packages.visionfive2-sdcard;

  });
}
