{ homeModules, ... }:

{
  imports = [
    "${homeModules}/common"

    "${homeModules}/desktops/hyprland"
    "${homeModules}/programs/ghostty.nix"
    "${homeModules}/programs/git.nix"
  ];

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
