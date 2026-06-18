{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
    };

    masApps = {
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;

      "Xcode" = 497799835;
    };

    # only gui apps since installing them via nix is hit or miss with updates in-app
    casks = [
      # browser
      "brave-browser"
      "firefox"
      "helium-browser"

      # social
      "discord"
      "signal"
      "slack"

      # screen
      "obs"

      # dev
      "jetbrains-toolbox"
      "visual-studio-code"
      "bruno"
      "arduino-ide"

      # image
      "gimp"
      "krita"
      "inkscape"
      "kicad"
      "bambu-studio"
      "prusaslicer"

      # media
      "spotify"
      "stolendata-mpv"

      # torrent
      "transmission"

      # games
      "roblox"
      "steam"
      "prismlauncher"
      "lunar-client"

      # productivity
      "notion"
      "obsidian"
      "ticktick"
      "anki"
      "bitwarden"

      # bench
      "geekbench"

      # mac/ios utils
      "thaw"
      "cyberduck" # gui file transfer
      "raycast" # launcher + hella hotkeys
      "powerflow" # battery history and monitoring for macOS and iOS
      "unnaturalscrollwheels" # scroll wheel fix on external mouse
      "pearcleaner" # clean up app files

      # local llms
      "lm-studio"

      # qemu
      "utm"
    ];

    taps = [
      "lzt1008/powerflow"
    ];
  };
}
