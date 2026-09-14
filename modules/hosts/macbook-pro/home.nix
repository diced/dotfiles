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
    "${homeModules}/programs/brew/mpv.nix"

    "${homeModules}/programs/git.nix"
    "${homeModules}/programs/nix-index.nix"
    "${homeModules}/utils/deploy.nix"
    "${homeModules}/programs/ssh.nix"
  ];

  home = {
    packages = [
      neovim
    ];

    sessionVariables = {
      "LC_ALL" = "";
      "EDITOR" = "${neovim}/bin/nvim";
    };
  };
}
