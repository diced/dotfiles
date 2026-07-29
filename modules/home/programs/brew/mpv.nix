{ pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      duti
    ];

    file.".config/mpv/mpv.conf".text = ''
      sub-font-size=40
      sub-margin-y=70

      sub-color='#FFFFFFFF'
      sub-outline-color='#000000'
      sub-outline-size=6

    '';

    file.".config/duti/video.defaults".text = ''
      com.colliderli.iina mkv all
      com.colliderli.iina mp4 all
      com.colliderli.iina mov all
      com.colliderli.iina avi all
    '';

    activation.setDefaultVideoApp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.duti}/bin/duti ~/.config/duti/video.defaults
    '';
  };
}
