{ ... }:

{
  programs.git = {
    enable = true;
    userName = "diced";
    userEmail = "git@diced.sh";
    signing = {
      key = "436B2B0FA0DCA354";
      signByDefault = true;
    };
  };
}
