{ lib, ... }:

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
            action = lib.generators.mkLuaInline ''
              function(session_name)
                require("auto-session").RestoreSession(session_name)
              end
            '';
            dirs = lib.generators.mkLuaInline ''
              function()
                sessions = require("auto-session.lib").get_session_list(vim.fn.stdpath "data" .. "/sessions/") 

                local display_names = vim.tbl_map(function(session)
                  return session.display_name
                end, sessions)

                return display_names
              end
            '';
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
            key = "<leader>ss";
            desc = "Search Sessions";
            action = ":SessionSearch";
          }
        ];
      };
    };
  };
}
