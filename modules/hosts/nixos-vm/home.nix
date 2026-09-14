{ homeModules, ... }:

{
  imports = [
    "${homeModules}/common"

    "${homeModules}/desktops/hyprland"
    "${homeModules}/programs/ghostty.nix"
    "${homeModules}/programs/git.nix"
  ];
}
