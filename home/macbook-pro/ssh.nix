_:

{
  home.file.".ssh/config".text = ''
    Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/macbook_pro
  '';
}
