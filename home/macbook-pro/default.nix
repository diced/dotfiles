{
  homeModules,
  mkNeovim,
  ...
}:

let
  neovim = (mkNeovim "aarch64-darwin").neovim;
in
{
  imports = [
    "${homeModules}/common"

    "${homeModules}/programs/ghostty.nix"
    "${homeModules}/programs/brew/mpv.nix"

    "${homeModules}/programs/git.nix"
    "${homeModules}/utils/switch.nix"
    "${homeModules}/programs/nix-index.nix"
    "${homeModules}/programs/nh.nix"
  ];

  home.packages = [
    neovim
  ];

  programs.home-manager.enable = true;

  home.sessionVariables = {
    "LC_ALL" = "";
    "EDITOR" = "${neovim}/bin/nvim";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
