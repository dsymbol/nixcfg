{ pkgs, user, host, ... }:

{
  # Legacy BIOS
  # boot.loader.grub.device = "/dev/sda"

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
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
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    # openssh.enable = true;
  };

  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   elisa
  #   gwenview
  #   okular
  #   oxygen
  #   khelpcenter
  #   plasma-browser-integration
  #   print-manager
  #   spectacle
  #   kwalletmanager
  #   kinfocenter
  # ];

}
