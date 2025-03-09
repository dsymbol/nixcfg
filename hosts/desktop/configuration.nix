{ pkgs, ... }:

{
  imports = [
    ../../modules/kde.nix
  ];

  networking.firewall.enable = true;
}
