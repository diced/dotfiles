{ pkgs, ... }:

{
  vim.telescope = {
    enable = true;

    setupOpts = {
      defaults = {
        color_devicons = true;
        file_ignore_patterns = [
          "node_modules"
          ".git/"
          "build/"
          "dist/"
        ];
      };

      pickers = {
        find_files = {
          find_command = [ "${pkgs.fd}/bin/fd" "--type" "f" "--hidden" "--exclude" ".git" "--exclude" "node_modules" ];
        }; 
      };
    };
  };
}
