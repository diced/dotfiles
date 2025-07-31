{ pkgs, ... }:

{
  home.packages = with pkgs; [
    udiskie
  ];

  services.udiskie = {
    enable = true;
    tray = "always";
  };
}
