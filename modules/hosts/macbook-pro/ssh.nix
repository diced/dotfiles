{ user, ... }:

{
  programs.ssh.settings = {
    "*" = {
      addKeysToAgent = true;
      useKeychain = true;
      identityFile = "/home/${user}.ssh/macbook_pro";
    };

    "github.com" = {
      hostName = "github.com";
      user = "git";
      identityFile = "/home/${user}.ssh/github";
    };

    "github-edu" = {
      hostName = "github.com";
      user = "git";
      identityFile = "/home/${user}.ssh/github_edu";
    };
  };
}
