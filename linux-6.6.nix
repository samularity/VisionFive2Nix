{ lib, callPackage, linuxPackagesFor, kernelPatches, ... }:

let
  modDirVersion = "6.7.0";
  linuxPkg = { lib, fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (args // {
      version = "${modDirVersion}-starfive-visionfive2";

      src = fetchFromGitHub {
        owner = "starfive-tech";
        repo = "linux";
        rev = "9fbbff4c77307f8f483d5e3237b77b6c4b02f066";
        hash = "sha256-iO7tnnWYfveVbyvVZKL0dDLwONijt1n0RUD1kTkOQgg=";
      };

      inherit modDirVersion kernelPatches;

      structuredExtraConfig = with lib.kernel; {
        PINCTRL_STARFIVE_JH7110_SYS = yes;
        SERIAL_8250_DW = yes;
      };

      extraMeta.branch = "JH7110_VisionFive2_upstream";
    } // (args.argsOverride or { }));

in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))
