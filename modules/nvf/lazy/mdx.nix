{ pkgs, ... }:

{
  vim.lazy.plugins."mdx-nvim" = {
    package = pkgs.vimUtils.buildVimPlugin {
      pname = "mdx-nvim";
      version = "464a74be368dce212cff02f6305845dc7f209ab3";
      src = pkgs.fetchFromGitHub {
        owner = "davidmh";
        repo = "mdx.nvim";
        rev = "464a74be368dce212cff02f6305845dc7f209ab3";
        sha256 = "sha256-jpMcrWx/Rg9sMfkQFXnIM8VB5qRuSB/70wuSh6Y5uFk=";
      };
    };

    setupModule = "mdx";

    event = [ "BufEnter *.mdx" ];
  };
}
