{ ... }:

{
  vim.assistant = {
    copilot = {
      enable = true;

      setupOpts = {
        suggestion = {
          enabled = true;
          auto_trigger = true;
        };
      };
    };

    avante-nvim = {
      enable = true;

      setupOpts = {
        provider = "copilot";
      };
    };
  };
}
