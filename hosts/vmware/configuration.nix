{user, ...}:

{ 
  virtualisation.vmware.guest.enable = true; 
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = user;
  services.openssh.enable = true;
}