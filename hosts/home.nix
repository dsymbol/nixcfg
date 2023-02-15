{ pkgs, inputs, lib, user, ... }:

{
  home = {
    stateVersion = "22.11";
    username = user;
    homeDirectory = "/home/${user}";
  };
}
