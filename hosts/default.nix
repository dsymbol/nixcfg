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
      ./home/hardware.nix
      ./configuration.nix
      ./home
      home-manager.nixosModules.home-manager
      { home-manager = hmConfig // { users.${user} = { imports = [ ./home/home.nix ]; }; }; }
    ];
  };

  vmware = lib.nixosSystem {
    specialArgs = inheritable;
    modules = [
      ./vmware/hardware.nix
      ./configuration.nix
      ./home
      { virtualisation.vmware.guest.enable = true; }
      home-manager.nixosModules.home-manager
      { home-manager = hmConfig // { users.${user} = { imports = [ ./home/home.nix ]; }; }; }
    ];
  };
}
