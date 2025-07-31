{ homeModules, ... }:

{
  imports = [
    "${homeModules}/common"

    # broken as of 1.1.3, installed using brew for now
    # "${homeModules}/programs/ghostty.nix"
    "${homeModules}/programs/ghostty-brew.nix"
    "${homeModules}/programs/git.nix"
    "${homeModules}/utils/switch.nix"
    "${homeModules}/programs/nix-index.nix"
    "${homeModules}/programs/nh.nix"
  ];

  programs.home-manager.enable = true;

  home.sessionVariables = {
    "LC_ALL" = "";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
