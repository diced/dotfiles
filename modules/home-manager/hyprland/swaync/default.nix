{ lib, config, ... }:

{
  options.cfg.hyprland.swaync = lib.mkOption {
    type = lib.types.bool;
    default = config.cfg.hyprland.enable;
  };

  config = lib.mkIf config.cfg.hyprland.swaync {
    services.swaync = {
      enable = true;
      style = builtins.readFile ./swaync.css;

      settings = {
        positionX = "center";
        positionY = "top";
        
        control-center-margin-top = 12;
        control-center-margin-bottom = 12;
        control-center-margin-left = 12;
        control-center-margin-right = 12;
        control-center-height = 600;
        control-center-width = 500;

        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;

        timeout = 10;
        timeout-low = 5;
        timeout-critical = 15;

        fit-to-screen = false;

        notification-window-width = 500;
        keyboard-shortcuts = true;
        widgets = [
          "mpris"
          "volume"
          "backlight"
          "menubar"
          "buttons-grid"
          "title"
          "notifications"
        ];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear";
          };
          volume = {
            label = "󰕾 ";
          };
          backlight = {
            label = "󰃟 ";
          };
          buttons-grid = {
            actions = [
              {
                label = "󰝟";
                command = "wpctl set-mute @DEFAULT_SINK@ toggle";
                type = "toggle";
              }
              {
                label = "󰤄";
                command = "swaync-client -d";
                tyommand = "swaync-client -d";
                type = "toggle";
              }
              {
                label = "";
                command = "hyprlock";
              }
              {
                label = "";
                command = "wlogout";
              }
              {
                label = "";
                command = "XDG_CURRENT_DESKTOP=gnome gnome-control-center wifi";
              }
              {
                label = "";
                command = "XDG_CURRENT_DESKTOP=gnome gnome-control-center bluetooth";
              }
            ];
          };
          menubar = {
            "menu#power-buttons" = {
              label = "";
              position = "right";
              actions = [
                { label = "   Reboot"; command = "systemctl reboot"; }
                { label = "   Lock"; command = "hyprlock"; }
                { label = "   Logout"; command = "wlogout"; }
                { label = "   Shut down"; command = "systemctl poweroff"; }
              ];
            };
            "menu#powermode-buttons" = {
              label = "";
              position = "right";
              actions = [
                { label = "Performance"; command = "powerprofilesctl set performance"; }
                { label = "Balanced"; command = "powerprofilesctl set balanced"; }
              ];
            };
            "menu#screenshot-buttons" = {
              label = "";
              position = "left";
              actions = [
                { label = "   Entire screen"; command = "swaync-client -cp && sleep 1 && hyprshot -m output"; }
                { label = "   Select a region"; command = "swaync-client -cp && sleep 1 && hyprshot -m region"; }
                { label = "   Open screenshot folder"; command = "xdg-open ~/Pictures"; }
              ];
            };
          };
        };
      };
    };
  };
}