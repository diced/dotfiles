{ pkgs, ... }:
{
  imports = [
    ./hw.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "@admin"
        "diced"
      ];
    };

    #    gc = {
    #      automatic = true;
    #      interval = {
    #        Weekday = 0;
    #        Hour = 0;
    #        Minute = 0;
    #      };
    #      options = "--delete-older-than 30d";
    #    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-vm";

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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.diced = {
    isNormalUser = true;
    description = "diced";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
  ];

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  system.stateVersion = "25.05";
}
