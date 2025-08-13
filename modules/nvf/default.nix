{ ... }:

{
  imports = [
    ./plugins
    ./lazy
  ];

  vim = {
    viAlias = true;
    vimAlias = true;

    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    luaConfigRC.tabs = ''
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
    '';
  };
}
