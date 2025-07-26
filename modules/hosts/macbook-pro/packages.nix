{ pkgs, ... }:

{
  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  # packages
  environment.systemPackages = with pkgs; [
    # android
    android-tools
    scrcpy

    # nix
    nil
    nixfmt-rfc-style

    # docker
    colima
    docker
    docker-compose
    docker-buildx
    dive

    # video
    go-10mb-video
    yt-dlp
    wget
    ffmpeg

    # dev
    fnm
    gh
    hyperfine

    gnupg

    # manipulation
    imagemagick
    ghostscript

    # util
    macmon
    htop
    qemu-utils
  ];
}
