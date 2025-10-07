{ ... }:

let
  # quick helper function that moves into the next buffer
  #   if we are in the nvimtree buffer.
  fzfSafe = func: ''
    function()
      if vim.bo.filetype == "NvimTree" then
        vim.cmd("wincmd l")
      end
      require("fzf-lua").${func}()
    end
  '';
in
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
      action = fzfSafe "files";
      desc = "fzf-lua: Find Files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      lua = true;
      action = fzfSafe "live_grep";
      desc = "fzf-lua: Live Grep";
    }
    {
      mode = "n";
      key = "<leader>fb";
      lua = true;
      action = fzfSafe "buffers";
      desc = "fzf-lua: Buffers";
    }
    {
      mode = "n";
      key = "<leader>fc";
      lua = true;
      action = fzfSafe "git_commits";
      desc = "fzf-lua: Git Commits";
    }

    # lsp
    {
      mode = "n";
      key = "<leader>flr";
      lua = true;
      action = fzfSafe "lsp_references";
      desc = "fzf-lua: LSP References";
    }
    {
      mode = "n";
      key = "<leader>fld";
      lua = true;
      action = fzfSafe "lsp_declarations";
      desc = "fzf-lua: LSP Declarations";
    }
    {
      mode = "n";
      key = "<leader>flf";
      lua = true;
      action = fzfSafe "lsp_finder";
      desc = "FzfLua: LSP Finder";
    }
  ];
}
