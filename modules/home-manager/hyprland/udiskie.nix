{ lib, config, ... }:

{
  options.cfg.hyprland.udiskie = lib.mkOption {
    type = lib.types.bool;
    default = config.cfg.hyprland.enable;
  };

  config = lib.mkIf config.cfg.hyprland.udiskie {
    services.udiskie = {
      enable = true;
      tray = "always";
    };
  };
}