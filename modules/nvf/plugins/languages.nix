{ ... }:

{
  vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    nix = {
      enable = true;
      format.type = "nixfmt";
    };

    ts = {
      enable = true;
      format.enable = false;
      lsp.enable = false; # using typescript-tools instead.
    };

    css = {
      enable = true;
      format.enable = false;
    };

    astro = {
      enable = true;
      format.enable = false;
    };

    markdown = {
      enable = true;
      format.enable = false;
    };

    yaml = {
      enable = true;
      # disable for now since broken in v0.8
      lsp.enable = false;
    };

    go.enable = true;
    html.enable = true;
    lua.enable = true;
    python.enable = true;
    typst.enable = true;
    tailwind.enable = true;
    sql.enable = true;
    java.enable = true;
  };
}
