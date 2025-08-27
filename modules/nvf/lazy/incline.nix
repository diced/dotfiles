{ lib, pkgs, ... }:

let
  package = pkgs.vimPlugins.incline-nvim;
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "incline";

    setupOpts = {
      render = lib.generators.mkLuaInline ''
        function(props)
          local cwd = vim.fn.getcwd()
          local bufname = vim.api.nvim_buf_get_name(props.buf)

          local relative = bufname:gsub("^" .. vim.pesc(cwd) .. "/", "")

          return relative
        end
      '';
    };
  };
}
