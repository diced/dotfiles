{ pkgs, lib, ... }:

{
  # vim.dashboard.alpha = {
  #   enable = true;
  #   theme = "theta";
  # };

  vim.utility.snacks-nvim = {
    enable = true;

    setupOpts = {
      dashboard = {
        sections = [
          {
            section = "header";
          }
          {
            pane = 2;
            section = "terminal";
            cmd = "colorscript -e square";
            height = 5;
            padding = 1;
          }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            pane = 2;
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
          }
          {
            pane = 2;
            icon = " ";
            title = "Projects";
            section = "projects";
            indent = 2;
            padding = 1;
          }
          {
            pane = 2;
            icon = " ";
            title = "Git Status";
            section = "terminal";
            enabled = lib.generators.mkLuaInline "function() return Snacks.git.get_root() ~= nil end"; # placeholder
            cmd = "git status --short --branch --renames";
            height = 5;
            padding = 1;
            ttl = 5 * 60;
            indent = 3;
          }
        ];
      };
    };
  };

  vim.extraPackages = [ pkgs.dwt1-shell-color-scripts ];
}
