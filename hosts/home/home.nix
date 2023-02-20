{ pkgs, inputs, lib, user, ... }:

{
  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      vscode
      tldr
      ripgrep
      pfetch
      fd
      vlc
      ffmpeg
      rnix-lsp
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
        name = "Default";
        isDefault = true;
        search.default = "DuckDuckGo";
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          canvasblocker
          skip-redirect
          bitwarden
        ];
        extraConfig = lib.strings.concatStrings [
          (builtins.readFile "${inputs.arkenfox-userjs}/user.js")
          ''
            // enable location bar search
            user_pref("keyword.enabled", true);
            // enable live search suggestions
            user_pref("browser.search.suggest.enabled", true);
            user_pref("browser.urlbar.suggest.searches", true);
            // enable search and form history
            user_pref("browser.formfill.enable", true);
            // keep data on shutdown
            user_pref("privacy.clearOnShutdown.formdata", false);
            user_pref("privacy.clearOnShutdown.history", false);
            user_pref("privacy.clearOnShutdown.cookies", false);
            user_pref("privacy.clearOnShutdown.offlineApps", false);
            // resume previous session
            user_pref("browser.startup.page", 3);
            // show bookmarks toolbar at all times
            user_pref("browser.toolbars.bookmarks.visibility", "always");
            // disable firefox view
            user_pref("browser.tabs.firefox-view", false);
            // extra session data
            user_pref("browser.sessionstore.privacy_level", 0);
          ''
        ];
      };
    };

    git = {
      enable = true;
      package = pkgs.git;
      userName = "dsymbol";
      userEmail = "dsymbol@users.noreply.github.com";
      attributes = [ "*.sh mode=executable" ];
      extraConfig = {
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };
    };

    zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      shellAliases = {
        ls = "ls -l --color=auto";
        python = "python3";
        venv = ''if [ -d "venv" ]; then source venv/bin/activate; else python -m venv venv; fi'';
        finds = ''() { [ -z "$1" ] && set -- "."; fd --color=never --hidden . "$1" | fzf -i --multi --cycle; }'';
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
          "nix.enableLanguageServer" = true;
        };
        # extensions = with pkgs.vscode-extensions; [
        #   jnoortheen.nix-ide
        #   ms-python.python
        # ];
      };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --color=never --hidden";
      defaultOptions = [ "-i" "--multi" "--cycle" ];
    };

    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.90;
        scrolling.history = 10000;
        scrolling.multiplier = 3;
        font = {
          size = 11;
          normal.family = "JetBrainsMono Nerd Font";
          normal.style = "Regular";
          bold.family = "JetBrainsMono Nerd Font";
          bold.style = "Bold";
          italic.family = "JetBrainsMono Nerd Font";
          italic.style = "Italic";
          bold_italic.family = "JetBrainsMono Nerd Font";
          bold_italic.style = "Bold Italic";
        };
        # Copy on selection
        selection.save_to_clipboard = true;
        # Paste on right click
        mouse_bindings = [{ mouse = "Right"; action = "Paste"; }];
      };
    };
  };

  xdg.configFile = {
    # disable kscreenlocker
    # kwriteconfig5 --file kscreenlockerrc --group 'Daemon' --key Autolock false
    "./kscreenlockerrc".text = "[Daemon]\nAutolock=false";
  };
  
}
