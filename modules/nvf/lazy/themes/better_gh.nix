{ pkgs, ... }:

let
  commit = "6ccb59e23f1813f12a3bd31d42f4211634a095c2";
  package = pkgs.vimUtils.buildVimPlugin {
    pname = "better_gh-nvim";
    version = commit;
    src = pkgs.fetchFromGitHub {
      owner = "diced";
      repo = "better_gh.nvim";
      rev = commit;
      sha256 = "sha256-RJYQ/2b4CYjymEVj3dhbtYxxBKex4/IIs4NFc3TRVcQ=";
    };
  };
  # package = pkgs.vimUtils.buildVimPlugin {
  #   pname = "better_gh-nvim";
  #   version = "dev";
  #   src = /Users/diced/Projects/better_gh.nvim;
  # };
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "better_gh";
    lazy = false;
    priority = 1000;

    setupOpts = {
      # neogit_floating_backdrop = true;
    };

    after = ''
      vim.cmd.colorscheme("better_gh")
    '';

  };
}
