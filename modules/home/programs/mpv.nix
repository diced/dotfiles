{ ... }:

{
  programs.mpv = {
    enable = true;

    config = {
      sub-font-size = 50;
      sub-margin-y = 70;

      sub-color = "#FFFFFFFF";
      sub-outline-color = "#000000";
      sub-outline-size = 6;
    };
  };
}
