{ ... }:

{
  vim.keymaps = [
    # indentations
    {
      mode = "v";
      key = "<Tab>";
      action = ">gv";
      desc = "Indent selected lines";
      noremap = true;
      silent = true;
    }
    {
      mode = "v";
      key = "<S-Tab>";
      action = "<gv";
      desc = "Unindent selected lines";
      noremap = true;
      silent = true;
    }

    # copy/paste
    {
      mode = [
        "n"
        "x"
      ];
      key = "y";
      action = ''"+y'';
      desc = "Yank to system clipboard";
    }
  ];
}
