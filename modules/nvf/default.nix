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

    options = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      cursorline = true;

      guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25,r-cr:hor20,o:hor50";

      wrap = false;
    };
  };
}
