{
  nixpkgs,
  inputs,
  home-manager,
  username,
  ...
}:

{
  host,
  system,
}:

let
  inheritable = {
    inherit
      inputs
      username
      host
      ;
  };
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = inheritable;
  modules = [
    # allow extra packages
    {
      nixpkgs.config = {
        allowUnfree = true;
        allowBroken = true;
        allowUnsupportedSystem = true;
      };
    }

    # nixos related configuration
    ./configuration.nix
    ./${host}/hardware.nix
    ./${host}/configuration.nix

    # home-manager related configuration
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = inheritable;
        users.${username} = {
          imports = [
            ./home.nix
            ./${host}/home.nix
          ];
        };
      };
    }
  ];
}
