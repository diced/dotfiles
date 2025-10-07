{ ... }:

let
  bufferHotkey = direction: ''
    function()
      local ft = vim.bo.filetype

      if ft == "NvimTree" then
        vim.cmd("wincmd p")
        vim.cmd("b${direction}")
      else
        vim.cmd("b${direction}")
      end
    end
  '';
in
{
  imports = [
    ../lazy/harpoon.nix
  ];

  vim.keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<C-o>";
      lua = true;
      action = bufferHotkey "p";
      desc = "Previous Buffer";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<C-p>";
      lua = true;
      action = bufferHotkey "n";
      desc = "Next Buffer";
    }
  ];
}
