{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      add_newline = false;

      username = {
        show_always = false;
        format = " [$user]($style)@";
        style_user = "bold blue";
      };

      hostname = {
        ssh_only = true;
        format = "[$hostname]($style) in ";
        style = "bold blue";
      };

      shell = {
        disabled = false;
        zsh_indicator = "";
        bash_indicator = "bash ";

        format = "[$indicator]($style)";
      };

      character = {
        # ❯
        success_symbol = "[>](bold blue)";
        error_symbol = "[>](bold red)";
      };

      directory = {
        read_only = " ";
        truncate_to_repo = true;
      };

      docker_context.symbol = " ";
      git_branch.symbol = " ";
      hg_branch.symbol = " ";
      golang.symbol = " ";
      python.symbol = " ";
      rust.symbol = " ";

      nix_shell = {
        format = "in [$symbol$state( \\($name\\))]($style) ";
        symbol = " ";
      };

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
