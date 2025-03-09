{ lib, config, ... }:

{
  options.cfg.hyprland.hyprlock = lib.mkOption {
    type = lib.types.bool;
    default = config.cfg.hyprland.enable;
  };

  config = lib.mkIf config.cfg.hyprland.hyprlock {
    programs.hyprlock = {
      enable = true;

      settings = {
        background = {
          color = "rgb(0, 0, 0)";
        };

        input-field = [
          {
            monitor = "eDP-1";

            size = "300, 50";
            valign = "center";
            position = "0%, -100%";

            outline_thickness = 1;

            font_color = "rgb(ffffff)";
            outer_color = "rgba(180, 180, 180, 0.5)";
            inner_color = "rgba(200, 200, 200, 0.1)";
            check_color = "rgba(247, 193, 19, 0.5)";
            fail_color = "rgba(255, 106, 134, 0.5)";

            fade_on_empty = false;
            placeholder_text = "Enter Password";

            rounding = 4;

            dots_spacing = 0.2;
            dots_center = true;
            dots_fade_time = 100;

            shadow_color = "rgba(0, 0, 0, 0.1)";
            shadow_size = 7;
            shadow_passes = 2;
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME12";
            font_size = 80;
            font_family = "Cantarell Bold";
            color = "rgb(ffffff)";

            position = "0%, 50%";

            valign = "center";
            halign = "center";

            shadow_color = "rgba(0, 0, 0, 0.1)";
            shadow_size = 20;
            shadow_passes = 2;
            shadow_boost = 0.3;
          }
          {
            monitor = "";
            text = "cmd[update:3600000] date +'%a %b %d'";
            font_size = 30;
            font_family = "Cantarell Bold";
            color = "rgb(ffffff)";

            position = "0%, 150%";

            valign = "center";
            halign = "center";

            shadow_color = "rgba(0, 0, 0, 0.1)";
            shadow_size = 20;
            shadow_passes = 2;
            shadow_boost = 0.3;
          }
        ];
      };
    };
  };
}