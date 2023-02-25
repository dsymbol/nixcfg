{ pkgs, user, ... }:

{
  time.timeZone = "Europe/Athens";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System wide packages
  environment.systemPackages = with pkgs; [
    vim
    nano
    firefox
    python3
    git
    wget
    curl
    zip
    unzip
    xclip
    htop
    nixpkgs-fmt
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

  virtualisation.docker.enable = true;
  
  # User configuration
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = " ";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  system.stateVersion = "22.11";
}
