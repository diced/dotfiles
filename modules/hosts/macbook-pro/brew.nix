{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
    };

    # only gui apps since installing them via nix is hit or miss with updates in-app
    casks = [
      # browser
      "brave-browser"
      "firefox"

      # social
      "discord"

      # file sharing android
      "neardrop"
      "openmtp"

      # screenshot
      "ishare"

      # dev
      "ghostty"
      "jetbrains-toolbox"
      "visual-studio-code"
      "yaak"

      # image
      "gimp"
      "krita"

      # media
      "spotify"
      "jellyfin-media-player"
      "stolendata-mpv"

      # torrent
      "transmission"

      # games
      "roblox"
      "steam"
      "prismlauncher"
      "whisky"

      # productivity
      "notion"
      "obsidian"
      "ticktick"

      # bench
      "geekbench"

      # mac utils
      "jordanbaird-ice" # hide menu bar items
      "cyberduck" # gui file transfer
      "raycast" # launcher + hella hotkeys
      "powerflow" # battery history
      "unnaturalscrollwheels" # scroll wheel fix on external mouse
      "pearcleaner" # clean up app files

      # local llms
      "lm-studio"

      # qemu
      "utm"
    ];

    taps = [
      "lzt1008/powerflow"
      "grishka/grishka"
    ];
  };
}
