{ lib, pkgs, inputs, home-manager, user, host, ... }:

let
  inheritable = { inherit pkgs inputs user host; };
  hmConfig = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = inheritable;
  };
in
{
  home = lib.nixosSystem {
    specialArgs = inheritable;
    modules = [
      ./configuration.nix
      ./home/hardware.nix
      ./home/configuration.nix
      home-manager.nixosModules.home-manager
      { home-manager = hmConfig // { users.${user} = { imports = [ ./home/home.nix ]; }; }; }
    ];
  };

  vmware = lib.nixosSystem {
    specialArgs = inheritable;
    modules = [
      ./configuration.nix
      ./vmware/hardware.nix
      ./vmware/configuration.nix
      ./home/configuration.nix
      home-manager.nixosModules.home-manager
      { home-manager = hmConfig // { users.${user} = { imports = [ ./home/home.nix ]; }; }; }
    ];
  };
}
