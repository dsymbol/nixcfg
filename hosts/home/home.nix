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
      nixd
    ];
    username = user;
    homeDirectory = "/home/${user}";
  };

  programs = {
    librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enabled" = true;
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

      oh-my-zsh = {
        enable = true;
        theme = "gentoo";
        plugins = [ "colored-man-pages" ];
      };

      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        # misc
        ls = "ls -l --color=auto";
        # python
        python = "python3";
        venv = ''if [ -d "venv" ]; then source venv/bin/activate; else python -m venv venv; fi'';
        # nix
        napply = "sudo nixos-rebuild switch --flake ~/nixcfg";
        nupdate = "nix flake update ~/nixcfg";
        hmapply = "home-manager switch --flake ~/nixcfg";
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
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
          ];
          userSettings = {
            "files.autoSave" = "afterDelay";
            "explorer.confirmDelete" = false;
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";

            "[python]" = {
              "editor.defaultFormatter" = "ms-python.black-formatter";
              "editor.formatOnSave" = true;
              "editor.codeActionsOnSave" = {
                "source.organizeImports" = "explicit";
                "source.unusedImports" = "explicit";
              };
            };
          };
        };

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
