{
  description = "NixOS Deterministic Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      user = "";
      host = "";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowBroken = true;
          allowUnsupportedSystem = true;
          allowUnfree = true;
        };
        overlays = [ inputs.nur.overlay ];
      };

    in
    {
      nixosConfigurations = import ./hosts {
        inherit (nixpkgs) lib;
        inherit pkgs inputs home-manager user host;
      };

      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs user; };
        modules = [ ./hosts/home/home.nix ];
      };
    };
}
