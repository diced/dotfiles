{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "switch" (builtins.readFile ../../switch.sh))
  ];
}
