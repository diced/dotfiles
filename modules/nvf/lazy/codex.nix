{ pkgs, ... }:

let
  package = pkgs.vimUtils.buildVimPlugin {
    pname = "codex-nvim";
    version = "4753819aa67ca1a05001e8e9cce721da0c94a93f";
    src = pkgs.fetchFromGitHub {
      owner = "nwiizo";
      repo = "codex.nvim";
      rev = "4753819aa67ca1a05001e8e9cce721da0c94a93f";
      sha256 = "sha256-AwNFRcT2HdCnwzRhkGin/WeFR30WUHwmpEQE7pXHtOo=";
    };
  };
in
{
  vim.lazy.plugins."${package.pname}" = {
    inherit package;

    setupModule = "codex";

    cmd = [
      "Codex"
      "CodexOpen"
      "CodexFocus"
      "CodexResume"
      "CodexContinue"
      "CodexFork"
      "CodexReview"
      "CodexImage"
      "CodexPrompt"
      "CodexSend"
      "CodexSendVisual"
      "CodexAdd"
      "CodexTreeAdd"
      "CodexDiff"
      "CodexInterrupt"
      "CodexStatus"
      "CodexStop"
      "CodexHealth"
    ];
  };
}
