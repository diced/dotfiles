{ homeModules, mkNeovim, ... }:

let
  neovim = (mkNeovim "aarch64-linux").neovim;
in
{
  imports = [
    "${homeModules}/common"

    "${homeModules}/programs/git.nix"
    "${homeModules}/programs/nh.nix"
    "${homeModules}/utils/switch.nix"
  ];

  home.packages = [
    neovim
  ];

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
