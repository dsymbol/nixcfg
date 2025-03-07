{
  pkgs,
  inputs,
  lib,
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
    brave
    bat
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
    ];
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
      grep = "grep --color=auto";
      cat = "bat --paging=never";
      # python
      python = "python3";
      venv = ''if [ -d "venv" ]; then source venv/bin/activate; else python -m venv venv; fi'';
      # nix
      switch = "sudo nixos-rebuild switch --flake ~/nixcfg";
      update = "nix flake update ~/nixcfg";
      hm-switch = "home-manager switch --flake ~/nixcfg";
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
