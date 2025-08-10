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
    go-10mb-video # from overlay
    yt-dlp
    wget
    ffmpeg
    fladder # from overlay

    # dev
    gh
    hyperfine
    nodejs_24
    corepack_24
    go
    git

    # manipulation
    imagemagick
    ghostscript

    # util
    macmon
    htop
    qemu-utils
  ];
}
