{ pkgs, user, host, ... }:

{
  imports = [ ./hardware.nix ];

  # Enable vmtools
  virtualisation.vmware.guest.enable = true;

  # Legacy BIOS
  # boot.loader.grub.device = "/dev/sda"

  # UEFI
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
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = user;
    };
    openssh = {
      enable = true;
      settings.permitRootLogin = "yes";
    };
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
