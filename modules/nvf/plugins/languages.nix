{ ... }:

{
  vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    nix = {
      enable = true;
      format.type = [ "nixfmt" ];
    };

    typescript = {
      enable = true;
      extraDiagnostics.enable = false;
      format.enable = false;
      lsp.enable = false; # using ts v7 instead.
    };

    css = {
      enable = true;
      format.enable = false;
    };

    astro = {
      enable = true;
      extraDiagnostics.enable = false;
      format.enable = false;
    };

    svelte = {
      enable = true;
      extraDiagnostics.enable = false;
      format.enable = false;
    };

    markdown = {
      enable = true;
      format.enable = false;
    };

    json = {
      enable = true;
      format.enable = false;
    };

    clang = {
      enable = true;
    };

    assembly = {
      enable = true;
      format.enable = false;
    };

    html = {
      enable = true;
    };

    go.enable = true;
    lua.enable = true;
    python.enable = true;
    typst.enable = true;
    sql.enable = true;
    java.enable = true;
    yaml = {
      enable = true;
      format.enable = false;
    };
    rust.enable = true;
  };
}
