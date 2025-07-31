{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ghostty
  ];

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      font-family = "JetbrainsMono Nerd Font";
      shell-integration-features = true;
      theme = "dark:dark,light:light";
      font-feature = "-calt, -liga, -dlig";
      window-theme = "ghostty";
    };

    themes = {
      dark = {
        background = "#161616";
        foreground = "#ffffff";
        cursor-color = "#acb1ab";
        cursor-text = "#ffffff";
        selection-background = "#FFFFFF";
        selection-foreground = "#101010";

        palette = [
          "0=#232627"
          "1=#C0392B"
          "2=#8BD49C"
          "3=#FDBC4B"
          "4=#1D99F3"
          "5=#8E44AD"
          "6=#1ABC9C"
          "7=#FCFCFC"
          "8=#7F8C8D"
          "9=#D64030"
          "10=#1CDC9A"
          "11=#FDBC4B"
          "12=#3DAEE9"
          "13=#8E44AD"
          "14=#0DC9B8"
          "15=#FFFFFF"
        ];
      };

      light = {
        background = "#fcffff";
        foreground = "#232323";
        cursor-color = "#0055bb";
        selection-background = "#d4eaf3";
        selection-foreground = "#232323";

        palette = [
          "0=#eaefef"
          "1=#c42d2f"
          "2=#008a00"
          "3=#aa6100"
          "4=#004fc0"
          "5=#aa44c5"
          "6=#1f6fbf"
          "7=#232323"
          "8=#b5b8b8"
          "9=#cf2f4f"
          "10=#00845f"
          "11=#996c4f"
          "12=#065fff"
          "13=#7f5ae0"
          "14=#007a85"
          "15=#66657f"
        ];
      };
    };
  };
}
