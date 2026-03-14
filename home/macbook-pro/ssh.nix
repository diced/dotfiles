{ user, ... }:

{
  programs.ssh.matchBlocks."*" = {
    addKeysToAgent = true;
    useKeychain = true;
    identityFile = "/home/${user}.ssh/macbook_pro";
  };
}
