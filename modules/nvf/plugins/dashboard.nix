{ ... }:

{
  vim.utility.snacks-nvim = {
    enable = true;

    setupOpts = {
      dashboard = {
        sections = [
          {
            title = "neovim";
            align = "center";
            padding = 3;
          }
          {
            pane = 1;
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
          }
          {
            pane = 1;
            icon = " ";
            title = "Projects";
            section = "projects";
            indent = 2;
            padding = 1;
          }

          # keys
          {
            icon = " ";
            key = "q";
            desc = "Quit";
            action = ":qa";
          }
          {
            icon = " ";
            key = "s";
            desc = "Search Sessions";
            action = ":SessionSearch";
          }
        ];
      };
    };
  };
}
