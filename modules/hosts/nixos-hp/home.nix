{
  homeModules,
  outputs,
  pkgs,
  ...
}:

let
  neovim = outputs.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
in
{
  imports = [
    "${homeModules}/common"

    "${homeModules}/programs/ghostty.nix"
    "${homeModules}/programs/git.nix"
  ];

  home.packages = [
    neovim
  ];

  home.sessionVariables = {
    "EDITOR" = "${neovim}/bin/nvim";
  };
}
