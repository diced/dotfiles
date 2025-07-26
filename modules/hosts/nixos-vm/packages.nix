{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    cantarell-fonts
  ];

  environment.systemPackages = with pkgs; [
  ];
}
