{ pkgs, ... }:

let
  package = pkgs.vimPlugins.catppuccin-nvim;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "catppuccin";

    lazy = false;
    priority = 1000;

    after = ''
      vim.cmd('colorscheme catppuccin-mocha')

      vim.api.nvim_set_hl(0, "Cursor", { fg = "NONE", bg = "#1f6feb" })

      vim.api.nvim_set_hl(0, "CustomJsxAttr",  { fg = "#79C0FF" })
      vim.api.nvim_set_hl(0, "CustomJsxTag",  { fg = "#7EE787" })
      vim.api.nvim_set_hl(0, "CustomJsxDelimiter", { fg = "#E5EDF3" })
      vim.api.nvim_set_hl(0, "CustomVariable", { fg = "#79c0ff" })
      vim.api.nvim_set_hl(0, "CustomNvimTreeText", { fg = "#79c0ff" })
      vim.api.nvim_set_hl(0, "Function", { fg = "#d2a8ff" })

      vim.api.nvim_set_hl(0, "@tag.attribute.tsx", { link = "CustomJsxAttr" })
      vim.api.nvim_set_hl(0, "@tag", { link = "CustomJsxTag" })
      vim.api.nvim_set_hl(0, "@tag.builtin", { link = "CustomJsxTag" })
      vim.api.nvim_set_hl(0, "@tag.delimiter", { link = "CustomJsxDelimiter" })
      vim.api.nvim_set_hl(0, "@variable.tsx", { link = "CustomVariable" })
      vim.api.nvim_set_hl(0, "@variable.builtin.python", { link = "@variable" })
      vim.api.nvim_set_hl(0, "@property.json", { link = "CustomJsxTag" })
      vim.api.nvim_set_hl(0, "@property.yaml", { link = "CustomJsxTag" })
      vim.api.nvim_set_hl(0, "Operator", { fg = "#ff7b72" })

      vim.api.nvim_set_hl(0, "NvimTreeFolderName", { link = "CustomNvimTreeText" })
      vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { link = "CustomNvimTreeText" })
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { link = "CustomNvimTreeText" })

    '';

    setupOpts = {
      color_overrides = {
        mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#ff7b72";
          red = "#f38ba8";
          maroon = "#ffa657";
          peach = "#79c0ff";
          yellow = "#ffa657";
          green = "#a4d6ff";
          teal = "#ff7b72";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#79C0FF";
          lavender = "#cdd6f4";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#111111";
          mantle = "#161616";
          crust = "#1f1f1f";
        };
      };
    };
  };
}
