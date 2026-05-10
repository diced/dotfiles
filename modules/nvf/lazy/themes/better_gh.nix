{ pkgs, ... }:

let
  package = pkgs.vimUtils.buildVimPlugin {
    pname = "better_gh-nvim";
    version = "4667aeaf8b38601a1b4da24cf7b87b5bb0f94db9";
    src = pkgs.fetchFromGitHub {
      owner = "diced";
      repo = "better_gh.nvim";
      rev = "4667aeaf8b38601a1b4da24cf7b87b5bb0f94db9";
      sha256 = "sha256-dx1FS9DXEPT7zd3md7g9tRQaMQn2t8J/NWZsrAKY0c8=";
    };
  };
  # package = pkgs.vimUtils.buildVimPlugin {
  #   pname = "better_gh-nvim";
  #   version = "dev";
  #   src = /Users/diced/nvim_theme;
  # };
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "better_gh";
    lazy = false;
    priority = 1000;

    setupOpts = {
      neogit_floating_backdrop = true;
    };

    after = ''
      vim.cmd.colorscheme("better_gh")
    '';

  };
}
