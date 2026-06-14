{ homeModules, mkNeovim, ... }:

let
  neovim = (mkNeovim "x86_64-linux").neovim;
in
{
  imports = [
    "${homeModules}/common"

    "${homeModules}/programs/ghostty.nix"
    "${homeModules}/programs/git.nix"
    "${homeModules}/programs/nh.nix"
    "${homeModules}/utils/switch.nix"
  ];

  home.packages = [
    neovim
  ];

  programs.home-manager.enable = true;

  home.sessionVariables = {
    "EDITOR" = "${neovim}/bin/nvim";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
