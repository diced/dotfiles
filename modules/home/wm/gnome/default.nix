{ pkgs, lib, ... }:

let
  toggleTheme = pkgs.writeShellScript "toggle-theme" ''
    if test "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'prefer-light'"; then
      gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    else
      gsettings set org.gnome.desktop.interface color-scheme prefer-light
    fi'';
in
{
  home.packages = with pkgs.gnomeExtensions; [
    tailscale-qs
    vitals
    bluetooth-battery-meter
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          tailscale-qs.extensionUuid
          vitals.extensionUuid
          bluetooth-battery-meter.extensionUuid
        ];
        favorite-apps = [
          "brave-browser.desktop"
          "com.mitchellh.ghostty.desktop"
          "org.gnome.Nautilus.desktop"
          "code.desktop"
        ];
      };

      "org/gnome/desktop/interface" = {
        accent-color = "blue";
        clock-format = "12h";
        clock-show-weekday = true;
        cursor-size = 24;
        cursor-theme = "Adwaita";
        enable-animations = true;
        enable-hot-corners = false;
        gtk-enable-primary-paste = false;
        icon-theme = "Adwaita";
        locate-pointer = false;
        monospace-font-name = "JetBrainsMono Nerd Font Mono 12";
        show-battery-percentage = true;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>w" ];
      };

      "org/gnome/settings-daemon/plugins/power" = {
        # disables auto brightness from light sensors
        ambient-enabled = false;

        power-saver-profile-on-low-battery = true;

        # suspend after 15 minutes on ac+battery
        sleep-inactive-ac-type = "suspend";
        sleep-inactive-ac-timeout = 900;
        sleep-inactive-battery-type = "suspend";
        sleep-inactive-battery-timeout = 900;
      };

      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 300;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        control-center = [ "<Super>i" ];
        search = [ "<Super>space" ];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "ghostty";
        name = "Open Terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>t";
        command = "${toggleTheme}";
        name = "Toggle Theme";
      };

      "org/gnome/shell/extensions/vitals" = {
        hot-sensors = [ "_battery_rate_" ];
        show-temperature = false;
        show-fan = true;
        show-memory = true;
        show-processor = true;
        show-system = false;
        show-network = true;
        show-storage = false;
        show-battery = true;
        battery-slot = 1;
        show-voltage = false;
      };
    };
  };
}
