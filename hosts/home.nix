{
  pkgs,
  inputs,
  lib,
  username,
  ...
}:

{
  home = {
    stateVersion = "22.11";
    username = username;
    homeDirectory = "/home/${username}";
  };

  programs.zsh = {
    enable = true;
    history.ignoreDups = true;
  };
}