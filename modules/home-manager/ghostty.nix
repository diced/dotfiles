{ pkgs, lib, config, ... }:

{
  options.cfg.ghostty = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf config.cfg.ghostty {
    home.packages = with pkgs; [
      ghostty
    ];

    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        font-family = "JetBrainsMono Nerd Font";
        theme = "dark:dark,light:light";
        term = "xterm-256color";
        shell-integration-features = true;
        background-opacity = 1.00;
        background-blur = true;
      };

      themes = {
        dark = {
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

          background = "#000000";
          foreground = "#FCFCFC";
          cursor-color = "#FFFFFF";
          cursor-text = "#121212";
          selection-background = "#FFFFFF";
          selection-foreground = "#000000";
        };

        light = {
          palette = [
            "0=#232627"
            "1=#C0392B"
            "2=#8BD49C"
            "3=#FDBC4B"
            "4=#1D99F3"
            "5=#8E44AD"
            "6=#1ABC9C"
            "7=#f7f7f7"
            "8=#7F8C8D"
            "9=#D64030"
            "10=#1CDC9A"
            "11=#FDBC4B"
            "12=#3DAEE9"
            "13=#8E44AD"
            "14=#0DC9B8"
            "15=#FFFFFF"
          ];

          background = "#f7f7f7";
          foreground = "#434343";
          cursor-color = "#434343";
          cursor-text = "#ffffff";
          selection-background = "#BBBBBB";
          selection-foreground = "#434343";
        };
      };
    };
  };
}