{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  
    settings = {
      add_newline = false;

      username = {
        show_always = false;
        format = " [$user]($style)@";
        style_user = "bold blue";
      };

      hostname = {
        ssh_only = true;
        format = " [$hostname]($style) in ";
        style = "bold blue";
      };

      character = {
        success_symbol = "[❯](bold blue)";
      };

      directory = {
        read_only = " ";
        truncate_to_repo = true;
      };

      docker_context.symbol = " ";
      git_branch.symbol = " ";
      hg_branch.symbol = " ";
      golang.symbol = " ";
      nix_shell.symbol = " ";
      python.symbol = " ";
      rust.symbol = " ";

      java = {
        symbol = " ";
        detect_extensions = [
          "java"
          "class"
          "jar"
          "cljs"
          "cljc"
        ];
      };

      package = {
        symbol = "󰏗 ";
        display_private = true;
      };
    };
  };
}
