{ pkgs, inputs, lib, user, ... }:

{
  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      vscode
      tldr
      ripgrep
      pfetch
      nixpkgs-fmt
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    username = user;
    homeDirectory = "/home/${user}";
  };

  programs = {
    firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        search.default = "DuckDuckGo";
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [ ublock-origin ];
      };
    };

    zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      shellAliases = {
        ls = "ls -l --color=auto";
        python = "python3";
        venv = ''if [ -d "venv" ]; then source venv/bin/activate; else python -m venv venv; fi'';
        apply = "sudo nixos-rebuild switch --flake ~/nixos-config";
        update = "nix flake update ~/nixos-config --commit-lock-file";
      };
      initExtra = ''
        pfetch
      '';
      history = {
        ignoreDups = true;
        ignoreSpace = true;
      };
    };

    vscode =
      {
        enable = true;
        package = pkgs.vscode;
        userSettings = {
          "files.autoSave" = "afterDelay";
        };
        # extensions = with pkgs.vscode-extensions; [
        #   jnoortheen.nix-ide
        #   ms-python.python
        # ];
      };
    };

  xdg.configFile = {
    # disable kscreenlocker
    # kwriteconfig5 --file kscreenlockerrc --group 'Daemon' --key Autolock false
    "./kscreenlockerrc".text = "[Daemon]\nAutolock=false";
  };
  
}
