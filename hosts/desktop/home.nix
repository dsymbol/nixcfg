{
  pkgs,
  inputs,
  lib,
  username,
  ...
}:

{
  imports = [
    ../../modules/vscode.nix
  ];

  home.packages = with pkgs; [
    vscode
    ripgrep
    pfetch
    vlc
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
      search.default = "DuckDuckGo";

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
          user_pref("privacy.clearOnShutdown.cache", false);
          user_pref("privacy.clearOnShutdown_v2.cache", false);
          user_pref("privacy.clearOnShutdown.downloads", false);
          user_pref("privacy.clearOnShutdown.formdata", false);
          user_pref("privacy.clearOnShutdown.history", false);
          user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);
          user_pref("privacy.clearOnShutdown.cookies", false);
          user_pref("privacy.clearOnShutdown.offlineApps", false);
          user_pref("privacy.clearOnShutdown.sessions", false);
          user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);
          // show bookmarks toolbar at all times
          user_pref("browser.toolbars.bookmarks.visibility", "always");
          // disable firefox view
          user_pref("browser.tabs.firefox-view", false);
          // extra session data
          user_pref("browser.sessionstore.privacy_level", 0);
          user_pref("privacy.cpd.offlineApps", false);
          user_pref("privacy.cpd.history", false);
        ''
      ];
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "dsymbol";
    userEmail = "dsymbol@users.noreply.github.com";
    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };

  programs.zsh = {
    enable = true;

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
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
