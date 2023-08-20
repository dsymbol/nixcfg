{ pkgs, inputs, lib, user, ... }:

{
  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      vim
      nano
      firefox
      git
      wget
      curl
      zip
      unzip
      xclip
      htop
      nixpkgs-fmt
      vscode
      tldr
      ripgrep
      pfetch
      vlc
      ffmpeg
      rnix-lsp
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
      extraConfig = {
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };
    };

    zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      shellAliases = {
        # misc
        ls = "ls -l --color=auto";
        # python
        python = "python3";
        venv = ''if [ -d "venv" ]; then source venv/bin/activate; else python -m venv venv; fi'';
        # nix
        napply = "sudo nixos-rebuild switch --flake ~/nixcfg";
        nupdate = "nix flake update ~/nixcfg";
        # docker 
        dshell = ''() { [ -z "$1" ] && set -- "ubuntu"; docker run -d -t --rm $1; docker exec -it $(docker container ls -q -n 1) /bin/sh; }'';
        dprune = ''docker system prune -a'';
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
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          ms-python.python
          streetsidesoftware.code-spell-checker
          # ms-vscode.powershell
          foxundermoon.shell-format
          redhat.vscode-yaml
        ];
      };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };

}
