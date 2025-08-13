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

    telescope.enable = true;

    visuals = {
      rainbow-delimiters.enable = true;
      fidget-nvim.enable = true;
      indent-blankline.enable = true;
      nvim-web-devicons.enable = true;
      nvim-scrollbar.enable = true;
    };

    ui = {
      colorizer = {
        enable = true;
        setupOpts = {
          filetypes."*" = {};
        };
      };

      noice.enable = true;
      illuminate.enable = true;
    };

    statusline = {
      lualine = {
        enable = true;
      };
    };

    tabline = {
      nvimBufferline.enable = true;
    };

    treesitter = {
      enable = true;
      context.enable = true;
      autotagHtml = true;
      fold = true;
    };

    lsp = {
      enable = true;
      inlayHints.enable = true;
      formatOnSave = true;
      trouble.enable = true;
      otter-nvim.enable = true;
    };

    autocomplete = {
      blink-cmp.enable = true;
    };

    comments.comment-nvim.enable = true;
    autopairs.nvim-autopairs.enable = true;

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
        format.enable = true;
      };

      css.enable = true;
      go.enable = true;
    };
  };
}
