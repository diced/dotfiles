{ user, ... }:

{
  programs.ssh.settings."*" = {
    addKeysToAgent = true;
    useKeychain = true;
    identityFile = "/home/${user}.ssh/macbook_pro";
  };
}
