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
    docker-sbx
    dive

    # video
    go-10mb-video # from overlay
    yt-dlp
    wget
    ffmpeg
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
    unstable.codex
    rustup
    typst

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
