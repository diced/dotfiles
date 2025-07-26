{ ... }:

{
  imports = [
    ./brew.nix
    ./packages.nix
    ../../overlays/packages.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "@admin"
        "diced"
      ];
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # disable nix channels
    channel.enable = false;
  };

  users.users.diced = {
    name = "diced";
    home = "/Users/diced";
  };

  # use touchid for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    # set for backwards compat
    stateVersion = 6;

    primaryUser = "diced";

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
          { app = "/System/Applications/Launchpad.app"; }
          { app = "/System/Applications/System Settings.app"; }
          { app = "/System/Applications/Utilities/Activity Monitor.app"; }
          { app = "/Applications/Brave Browser.app"; }
          { app = "/Applications/Spotify.app"; }
          { app = "/Applications/Discord.app"; }
          { app = "/Applications/Ghostty.app"; }
          { app = "/Applications/Visual Studio Code.app"; }
          { app = "/Applications/TickTick.app"; }
          { app = "/Applications/Obsidian.app"; }
          { app = "/Applications/Prism Launcher.app"; }
          { app = "/Applications/Steam.app"; }
          { app = "/Applications/Jellyfin Media Player.app"; }
        ];

        persistent-others = [
          "file:///Users/diced/Downloads"
          "file:///Users/diced/Pictures/Screenshots"
        ];
      };
    };
  };
}
