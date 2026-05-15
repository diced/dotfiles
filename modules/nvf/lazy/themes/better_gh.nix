{ pkgs, ... }:

let
  commit = "5e67cee1b6f8cedbad813776b6514ae93c65f7a6";
  package = pkgs.vimUtils.buildVimPlugin {
    pname = "better_gh-nvim";
    version = commit;
    src = pkgs.fetchFromGitHub {
      owner = "diced";
      repo = "better_gh.nvim";
      rev = commit;
      sha256 = "sha256-NAMGeDB1ABidyuCdmulg6hQtF92NsHJHVyclLEAOgKY=";
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
      # neogit_floating_backdrop = true;
    };

    after = ''
      vim.cmd.colorscheme("better_gh")
    '';

  };
}
