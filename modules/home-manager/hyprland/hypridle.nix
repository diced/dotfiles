{ lib, config, ... }:

let timeout = 300; in {
  options.cfg.hyprland.hypridle = lib.mkOption {
    type = lib.types.bool;
    default = config.cfg.hyprland.enable;
  };

  config = lib.mkIf config.cfg.hyprland.hypridle {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = timeout - 10;
            on-timeout = "brillo -O; brillo -q -u 300000 -S 5";
            on-resume = "brillo -I -u 300000";
          }
          {
            inherit timeout;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = timeout + 60;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = timeout + 60;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
  };
}