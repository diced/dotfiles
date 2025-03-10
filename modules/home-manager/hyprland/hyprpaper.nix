{ config, lib, pkgs, ... }:

let setWallpaperOnLogin = pkgs.writeShellScript "wallpaper-on-login" ''
  current=$(gsettings get org.gnome.desktop.interface color-scheme)

  if test "$current" = "'prefer-light'"; then
    hyprctl hyprpaper wallpaper ",${../../../wallpapers/light.png}"
  else
    hyprctl hyprpaper wallpaper ",${../../../wallpapers/dark.png}"
  fi''; 
in {
  options.cfg.hyprland.hyprpaper = lib.mkOption {
    type = lib.types.bool;
    default = config.cfg.hyprland.enable;
  };

  config = lib.mkIf config.cfg.hyprland.hyprpaper {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;

        preload = [
          "${../../../wallpapers/light.png}"
          "${../../../wallpapers/dark.png}"
        ];

        wallpaper = [", ${../../../wallpapers/light.png}"];
      };
    };

    systemd.user.services.hyprpaper.serviceConfig.ExecStartPost = "${setWallpaperOnLogin}";
  };
}
