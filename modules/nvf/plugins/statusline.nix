{ ... }:

{
  vim.statusline = {
    lualine = {
      enable = true;

      activeSection.b = [
        ''
          {
            "filetype",
            colored = true,
            icon_only = true,
            icon = { align = 'left' }
          }
        ''
        ''
          {
            "filename",
            symbols = {modified = ' ', readonly = ' '},
            separator = {right = ''},
            path = 1
          }
        ''
        ''
          {
            "",
            draw_empty = true,
            separator = { left = '', right = '' }
          }
        ''
      ];
    };
  };
}
