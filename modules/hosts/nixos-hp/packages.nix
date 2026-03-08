{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    cantarell-fonts
  ];

  programs = {
    nix-ld.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # 27031..27036
      dedicatedServer.openFirewall = true; # 27015
      localNetworkGameTransfers.openFirewall = true; # 27040
    };
  };

  environment.systemPackages = with pkgs; [
    ghostty
    discord

    unstable.brave

    (heroic.override {
      extraPkgs =
        pkgs': with pkgs'; [
          gamescope
          gamemode
        ];
    })
  ];
}
