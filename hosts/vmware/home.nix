{
  pkgs,
  inputs,
  lib,
  username,
  ...
}:

{
  imports = [
    ../../modules/vscode.nix
  ];
}
