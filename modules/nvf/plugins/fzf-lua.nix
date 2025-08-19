{ ... }:

{
  vim.fzf-lua = {
    enable = true;

    setupOpts = {
      previewers.builtin.snacks_image.enabled = false;
    };
  };

  vim.keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      lua = true;
      action = ''function() require("fzf-lua").files() end'';
      desc = "FzfLua: Find Files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      lua = true;
      action = ''function() require("fzf-lua").live_grep() end'';
      desc = "FzfLua: Live Grep";
    }

    # lsp
    {
      mode = "n";
      key = "<leader>flr";
      lua = true;
      action = ''function() require("fzf-lua").lsp_references() end'';
      desc = "FzfLua: LSP References";
    }
    {
      mode = "n";
      key = "<leader>fld";
      lua = true;
      action = ''function() require("fzf-lua").lsp_declarations() end'';
      desc = "FzfLua: LSP Declarations";
    }
    {
      mode = "n";
      key = "<leader>flf";
      lua = true;
      action = ''function() require("fzf-lua").lsp_finder() end'';
      desc = "FzfLua: LSP Finder";
    }
  ];
}
