{ lib, ... }:

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
      extensions.markview-nvim = {
        enable = true;
        setupOpts = {
          preview.enable = false;
        };
      };
      lsp.servers = [ "rumdl" ];
    };

    json = {
      enable = true;
      format.enable = false;
    };

    clang = {
      enable = true;
    };

    make.enable = true;

    assembly = {
      enable = true;
      format.enable = false;
    };

    html = {
      enable = true;
    };

    typst = {
      enable = true;
      # using tinymist builtin formatter
      format.enable = false;
    };

    yaml = {
      enable = true;
      format.enable = false;
    };

    go.enable = true;
    lua.enable = true;
    python.enable = true;
    sql.enable = true;
    java.enable = true;
    rust.enable = true;
  };

  # markview keys
  vim.keymaps = [
    {
      mode = "n";
      key = "<leader>s";
      action = "<CMD>Markview splitToggle<CR>";
    }
  ];
}
