{
  pkgs,
  lib,
  host,
  ...
}:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "switch" ''
      export CONFIG_NAME=${lib.escapeShellArg host}
      ${builtins.readFile ../../../switch.sh}
    '')
  ];
}
