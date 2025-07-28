{ homeModules, ... }:

{
  imports = [
    "${homeModules}/common"

    "${homeModules}/wm/hyprland"
    "${homeModules}/ghostty.nix"
    "${homeModules}/git.nix"
  ];

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
