{ homeModules, pkgs, ... }:

{
  imports = [
    "${homeModules}/common"

    "${homeModules}/programs/git.nix"
    "${homeModules}/programs/nh.nix"
    "${homeModules}/utils/switch.nix"
  ];

  programs.home-manager.enable = true;

  home.sessionVariables = {
    "EDITOR" = "${pkgs.neovim}/bin/nvim";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
