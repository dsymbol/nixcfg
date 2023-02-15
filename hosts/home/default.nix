{ pkgs, user, host, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
      };
    };
  };

  networking = {
    hostName = host;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # List services that you want to enable:
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      excludePackages = [ pkgs.xterm ];
      # Enable the Plasma 5 Desktop Environment.
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
    # openssh.enable = true;
  };

  services.xserver.desktopManager.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    plasma-browser-integration
    print-manager
    spectacle
    kwalletmanager
    kinfocenter
  ];

}
