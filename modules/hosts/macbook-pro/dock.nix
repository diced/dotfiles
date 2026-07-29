{ pkgs, ... }:

{
  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.1;
    autohide-time-modifier = 0.4;

    show-recents = true;

    tilesize = 50;

    persistent-apps = [
      { app = "/System/Applications/System Settings.app"; }
      { app = "/System/Applications/Utilities/Activity Monitor.app"; }
      { app = "/System/Applications/Calendar.app"; }
      { app = "/Applications/Helium.app"; }
      { app = "/Applications/Brave Browser.app"; }
      { app = "/Applications/Spotify.app"; }
      { app = "/System/Applications/Mail.app"; }
      { app = "/System/Applications/Phone.app"; }
      { app = "/System/Applications/Messages.app"; }
      { app = "/Applications/Discord.app"; }
      { app = "/Applications/Slack.app"; }
      { app = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
      { app = "/Applications/Visual Studio Code.app"; }
      { app = "/Applications/TickTick.app"; }
      { app = "/Applications/Obsidian.app"; }
      { app = "/Applications/Prism Launcher.app"; }
      { app = "/Applications/Steam.app"; }
      { app = "/System/Applications/iPhone Mirroring.app"; }
      { app = "/Applications/Jellyfin Desktop.app"; }
    ];

    # persistent-others = [
    #   "file:///Users/${user}/Downloads"
    #   "file:///Users/${user}/Pictures/Screenshots"
    # ];
  };
}
