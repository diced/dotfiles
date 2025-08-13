{ pkgs, ... }:

{
  vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    nix = {
      enable = true;
      format.package = pkgs.nixfmt-rfc-style;
    };

    ts = {
      enable = true;
      format.enable = false;
    };

    css = {
      enable = true;
      format.enable = false;
    };

    astro = {
      enable = true;
      format.enable = false;
    };

    go.enable = true;
    markdown.enable = true;
    html.enable = true;
    lua.enable = true;
    python.enable = true;
    typst.enable = true;
    tailwind.enable = true;
    sql.enable = true;
    java.enable = true;
  };
}
