{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "deploy-nixos" (builtins.readFile ../../../deploy-nixos.sh))
  ];
}
