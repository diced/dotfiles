{ homeModules, pkgs, ... }:

{
  imports = [
    "${homeModules}/common"

    "${homeModules}/programs/git.nix"
  ];

  home.sessionVariables = {
    "EDITOR" = "${pkgs.neovim}/bin/nvim";
  };
}
