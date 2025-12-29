{ ... }:

{
  programs.git = {
    enable = true;

    settings.user = {
      name = "diced";
      email = "git@diced.sh";
    };

    signing = {
      key = "436B2B0FA0DCA354";
      signByDefault = true;
    };
  };
}
