{ lib, pkgs, inputs, home-manager, user, hosts, ... }:
let
  mkHost = host:
    let
      inheritable = { inherit pkgs inputs user host; };
      hmModule = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = inheritable;
            users.${user} = { imports = [ ./${host}/home.nix ]; };
          };
        }
      ];
    in
    lib.nixosSystem {
      specialArgs = inheritable;
      modules = [
        ./configuration.nix
        ./${host}
      ] ++ hmModule;
    };
in
builtins.listToAttrs (map (host: { name = host; value = mkHost host; }) hosts)
