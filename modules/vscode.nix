{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        # ms-python.python
        # ms-python.black-formatter
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
}
