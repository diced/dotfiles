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

    "${homeModules}/programs/brew/ghostty.nix"
    "${homeModules}/programs/brew/mpv.nix"

    "${homeModules}/programs/git.nix"
    "${homeModules}/programs/nix-index.nix"
    "${homeModules}/utils/deploy.nix"
    "${homeModules}/programs/ssh.nix"
  ];

  programs.ssh.settings."*" = {
    addKeysToAgent = true;
    useKeychain = true;
  };

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
