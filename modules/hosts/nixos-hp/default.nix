{
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./hw.nix
    ./packages.nix
    ./nvidia.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "@admin"
        user
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-hp";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
      };
      pulse.enable = true;
    };

    openssh.enable = false;

    # gnome
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    thermald.enable = true;

    tailscale = {
      enable = true;
      openFirewall = true;
      extraSetFlags = [
        "--operator=${user}"
      ];
      extraUpFlags = [ "--ssh" ];
    };
  };

  security.rtkit.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
