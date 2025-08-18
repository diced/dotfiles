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
          {
            pane = 1;
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
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
          {
            icon = " ";
            key = "d";
            desc = "Open dotfiles";
            action = lib.generators.mkLuaInline ''
              function()
                local home = vim.fn.expand("$HOME")
                local dotfiles_path = home .. "/nix"

                require("auto-session").RestoreSession(dotfiles_path)
              end
            '';
          }
        ];
      };
    };
  };
}
