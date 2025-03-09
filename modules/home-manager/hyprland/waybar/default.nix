{ lib, config, ... }:

{
  options.cfg.hyprland.waybar = lib.mkOption {
    type = lib.types.bool;
    default = config.cfg.hyprland.enable;
  };

  config = lib.mkIf config.cfg.hyprland.waybar {
    programs.waybar = {
      enable = true;
      style = builtins.readFile ./waybar.css;

      settings = [{
        height = 30;
        spacing = 0;
        layer = "top";
        
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "wireplumber"
          "power-profiles-daemon"
          "battery"
        ];

        "hyprland/window" = {
          format = "{}";
          rewrite = {
            "(.*) - Brave" = "Brave";
            "(.*) - Visual Studio Code" = "Visual Studio Code";
          };
        };
        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          on-click = "activate";
          all-outputs = true;
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
          };
        };
        battery = {
          format = "<span color=\"#fff\">{icon} </span>  ({power} W)  {capacity}%";
          format-icons = ["" "" "" "" ""];
          on-click = "XDG_CURRENT_DESKTOP=gnome gnome-control-center power";
        };
        tray = {
          icon-size = 12;
          spacing = 8;
        };
        wireplumber = {
          format = "<span color=\"#fff\">{icon}</span>  {volume}%";
          format-muted = "<span color=\"#fff\"></span>";  

          format-icons = {
            default = ["" "" ""];
          };
        };
        clock = {
          "interval" = 30;
          "timezones" = [ "America/Los_Angeles" ];
          "format" = "{:L%b %d    %I:%M %p}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "on-click" = "swaync-client -t -sw";
        };
        power-profiles-daemon = {
          format = "<span color=\"#fff\">{icon}</span>";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
      }];
    };
  };
}