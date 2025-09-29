{ pkgs, user, ... }:

{
  imports = [
    ./brew.nix
    ./packages.nix
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

      dock = {
        autohide = true;
        autohide-delay = 0.1;
        autohide-time-modifier = 0.4;

        show-recents = true;

        tilesize = 50;

        persistent-apps = [
          { app = "/System/Applications/System Settings.app"; }
          { app = "/System/Applications/Utilities/Activity Monitor.app"; }
          { app = "/Applications/Brave Browser.app"; }
          { app = "/Applications/Spotify.app"; }
          { app = "/Applications/Microsoft Outlook.app"; }
          { app = "/Applications/Discord.app"; }
          { app = "/Applications/Slack.app"; }
          { app = "/Applications/Ghostty.app"; }
          { app = "/Applications/Visual Studio Code.app"; }
          { app = "/Applications/TickTick.app"; }
          { app = "/Applications/Obsidian.app"; }
          { app = "/Applications/Prism Launcher.app"; }
          { app = "/Applications/Steam.app"; }
          { app = "${pkgs.fladder}/Applications/Fladder.app"; }
        ];

        # persistent-others = [
        #   "file:///Users/${user}/Downloads"
        #   "file:///Users/${user}/Pictures/Screenshots"
        # ];
      };
    };
  };
}
