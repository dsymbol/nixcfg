{
  pkgs,
  lib,
  username,
  host,
  ...
}:

{
  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    initialPassword = " ";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };
  
  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";

  # uefi
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # bios
  # boot.loader = {
  #   grub.enable = true;
  #   grub.device = "/dev/sda";
  # };

  # Enable nix flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = host;
    networkmanager.enable = true;
    firewall.enable = lib.mkDefault true;
  };

  # System wide packages
  environment.systemPackages = with pkgs; [
    firefox
    vim
    nano
    python3
    git
    wget
    curl
    zip
    unzip
    htop
    nixd
    nixfmt-rfc-style
    tldr
  ];

  # System wide zsh shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "gentoo";
      plugins = [ "colored-man-pages" ];
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "22.11";
}
