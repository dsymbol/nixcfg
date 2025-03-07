{ username, ... }:

{
  imports = [
    ../../modules/kde.nix
  ];
  
  networking.firewall.enable = false;
  virtualisation.vmware.guest.enable = true;
  services.openssh.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = username;
  # wayland slow in vmware
  services.xserver.enable = true;
  services.displayManager.defaultSession = "plasmax11";
}
