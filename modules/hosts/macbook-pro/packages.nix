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
    unstable.scrcpy

    # nix
    nil
    nixfmt

    # docker
    unstable.colima
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
    fdk-aac-encoder

    # dev
    gh
    hyperfine
    nodejs_24
    corepack_24
    go
    git
    python314
    awscli2
    cmake
    pkg-config
    platformio
    opencode

    # manipulation
    imagemagick
    ghostscript

    # util
    macmon
    htop
    qemu-utils
    rsync
  ];
}
