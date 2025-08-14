{ pkgs, ... }:

{
  vim.lazy.plugins."github-nvim-theme" = {
    package = pkgs.vimUtils.buildVimPlugin {
      pname = "github-nvim-theme";
      version = "2010b7a62f6fed564f95b2a76bb04fb773c45691";
      src = pkgs.fetchFromGitHub {
        owner = "tim3nd";
        repo = "github-nvim-theme";
        rev = "2010b7a62f6fed564f95b2a76bb04fb773c45691";
        sha256 = "sha256-6mhku7huNkDBLHBQWpQgAFduquBQfCJ25Rldha42A/g=";
      };
    };

    lazy = false;
    priority = 1000;

    after = ''
      require('github-theme').compile()
      vim.cmd('colorscheme github_dark_default')

      vim.api.nvim_set_hl(0, "Cursor", { fg = "NONE", bg = "#1f6feb" })
    '';

    setupModule = "github-theme";
    setupOpts = {
      specs.github_dark_default = {
        bg0 = "#111111";
        bg1 = "#161616";
      };
      groups.all = {
        # blink intellisense window background
        BlinkCmpMenu.bg = "#1f1f1f";

        CursorLine.bg = "#1f1f1f";

        # treesitter
        TreesitterContextSeparator.fg = "#303237";

        # telescope colors
        TelescopeMatching = {
          bg = "#082238";
          fg = "#78bffd";
        };
        TelescopeNormal.bg = "#1f1f1f";
        TelescopeSelection.bg = "#111111";

        # copilot.lua colors
        CopilotSuggestion.fg = "#474a4f";
      };
    };
  };
}
