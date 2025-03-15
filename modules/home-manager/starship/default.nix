{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.cfg.starship = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf config.cfg.starship {
    home.packages = with pkgs; [
      starship
    ];

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = lib.importTOML ./starship.toml;
    };
  };
}
