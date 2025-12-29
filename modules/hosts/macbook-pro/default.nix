{ user, ... }:

{
  imports = [
    ./brew.nix
    ./packages.nix
    ./dock.nix

    ../../overlays/packages.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

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
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 15d";
    };

    # disable nix channels
    channel.enable = false;

    linux-builder = {
      enable = false;
      ephemeral = true;
      maxJobs = 4;
      config = {
        services.openssh.enable = true;
        virtualisation = {
          darwin-builder = {
            diskSize = 64 * 1024;
            memorySize = 16 * 1024;
          };
          cores = 8;
        };

        # nix.settings.experimental-features = "nix-command flakes";
      };
    };
  };

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  # use touchid for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    # set for backwards compat
    stateVersion = 6;

    primaryUser = user;

    # macos settings
    defaults = {
      NSGlobalDomain = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
      };

      finder = {
        AppleShowAllFiles = true;
        ShowPathbar = true;
      };

    };
  };
}
