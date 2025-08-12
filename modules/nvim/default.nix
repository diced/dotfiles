{
  pkgs,
  inputs,
  ...
}: {
  config.vim = {
    viAlias = true;
    vimAlias = true;

    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    luaConfigRC.tabs = ''
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
    '';

    theme = {
      enable = true;
      name = "github";
      style = "dark_default";
    };

    terminal.toggleterm = {
      enable = true;
    };

    filetree = {
      neo-tree.enable = true;
    };

    visuals = {
      rainbow-delimiters.enable = true;
    };

    ui = {
      colorizer = {
        enable = true;
        setupOpts = {
          filetypes."*" = {};
        };
      };

      noice.enable = true;
    };

    treesitter = {
      enable = true;
      context.enable = true;
      autotagHtml = true;

      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        typescript
      ];
    };

    lsp = {
      enable = true;
    };

    languages = {
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

      css.enable = true;
      go.enable = true;
    };
  };
}
