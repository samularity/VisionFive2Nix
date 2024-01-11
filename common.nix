{ config, pkgs, cmake-nix-hello-world, ... }: {

    # set password for ssh login
    users.users.nixos.password = "nixos";
    users.users.nixos.group = "nixos";
    users.groups.nixos = {};
    users.users.nixos.isNormalUser = true;
    
    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 23 50000 52000 ];
        allowedUDPPorts = [ 50000 50001 ];
        allowedUDPPortRanges = [
            { from = 19997; to = 19999; }
        ];
    };

    environment.systemPackages = with pkgs; [
        wget
        htop
        python3
        file
        #cmake-nix-hello-world.packages.${config.nixpkgs.crossSystem.system}.default
        #(callPackage ./cmake/package.nix {} ) # use for loacal package
    ];

    system.stateVersion = "23.05";
}