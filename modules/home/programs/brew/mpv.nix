{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    duti
  ];

  home.file.".config/mpv/mpv.conf".text = ''
    sub-font-size=50
    sub-margin-y=70

    sub-color='#FFFFFFFF'
    sub-outline-color='#000000'
    sub-outline-size=6
  '';

  home.file.".config/duti/video.defaults".text = ''
    io.mpv mp4 all
    io.mpv mkv all
    io.mpv mov all
    io.mpv avi all
    io.mpv webm all
  '';

  home.activation.setDefaultVideoApp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.duti}/bin/duti ~/.config/duti/video.defaults
  '';
}
