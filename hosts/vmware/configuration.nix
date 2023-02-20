{user, ...}:

{ 
  virtualisation.vmware.guest.enable = true; 
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = user;
}