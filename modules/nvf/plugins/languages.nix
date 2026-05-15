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

    svelte = {
      enable = true;
      format.enable = false;
    };

    markdown = {
      enable = true;
      format.enable = false;
    };

    clang = {
      enable = true;
    };

    go.enable = true;
    html.enable = true;
    lua.enable = true;
    python.enable = true;
    typst.enable = true;
    sql.enable = true;
    java.enable = true;
    yaml.enable = true;
    rust.enable = true;
    assembly.enable = true;
  };
}
