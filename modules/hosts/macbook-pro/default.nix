{ user, pkgs, ... }:

{
  imports = [
    ./brew.nix
    ./packages.nix
    ./dock.nix

    ../../overlays/packages.nix
  ];

  # fuck ass thing to get opencode to work
  system.activationScripts.postActivation.text = ''
    entitlements="$(mktemp)"
    cat > "$entitlements" << 'EOF'
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>com.apple.security.cs.allow-jit</key><true/>
          <key>com.apple.security.cs.allow-unsigned-executable-memory</key><true/>
          <key>com.apple.security.cs.disable-library-validation</key><true/>
      </dict>
      </plist>
    EOF

    find ${pkgs.opencode}/bin -maxdepth 1 -type f | while read -r f; do
      echo "  signing: $f" >&2
      chmod u+w "$f" 2>/dev/null || true
      /usr/bin/codesign --sign - --force --entitlements "$entitlements" "$f" 2>&1 | sed 's/^/    /' >&2
      chmod u-w "$f" 2>/dev/null || true
      /usr/bin/codesign -dv "$f" 2>&1 | sed 's/^/    verify: /' >&2
    done

    rm -f "$entitlements"
  '';

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
