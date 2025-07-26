{ pkgs, ... }:

{
  imports = [
    ./waybar
    ./swaync
    ./wlogout
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./udiskie.nix
  ];

  home.packages = with pkgs; [
    font-awesome

    # screen capture
    grim
    slurp
    hyprshot
    wl-clipboard
    ydotool

    ffmpeg
    wf-recorder

    # file manager
    nautilus
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      bind = [
        "$mod, Return, exec, ghostty"
        "$mod, W, killactive,"
        "$mod, E, exec, wlogout"
        "$mod, L, exec, hyprlock"
        # "$mod, T, exec, ${toggleTheme}"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod shift, 1, movetoworkspace, 1"
        "$mod shift, 2, movetoworkspace, 2"
        "$mod shift, 3, movetoworkspace, 3"
        "$mod shift, 4, movetoworkspace, 4"
        "$mod shift, 5, movetoworkspace, 5"
        "$mod shift, 6, movetoworkspace, 6"
        "$mod shift, 7, movetoworkspace, 7"
        "$mod shift, 8, movetoworkspace, 8"
        "$mod shift, 9, movetoworkspace, 9"
        "$mod shift, 0, movetoworkspace, 10"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, S, togglefloating,"

        # "$mod, space, exec, steam-run dlauncher-toggle"

        ", print, exec, hyprshot -m region"
        "ctrl, print, exec, hyprshot -m window -m active"
        "ctrl shift, print, exec, hyprshot -m output"

        "alt, tab, exec, hyprswitch gui --mod-key alt --key tab --close mod-key-release --reverse-key=key=grave --sort-recent && hyprswitch dispatch"
        "alt grave, tab, exec, hyprswitch gui --mod-key alt --key tab --close mod-key-release --reverse-key=key=grave --sort-recent && hyprswitch dispatch -r"

        ",XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
        ",XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"

        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 2%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 2%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      layerrule = [
        "blur,waybar"
        "blur,swaync-control-center"
        "blur,swaync-notification-window"
        "ignorezero,swaync-control-center"
        "ignorezero,swaync-notification-window"
        "ignorealpha 0.5,swaync-control-center"
        "ignorealpha 0.5,swaync-notification-window"
        "blur,gtk-layer-shell"
        "blur,logout_dialog"
      ];

      exec-once = [
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "gsettings set org.gnome.desktop.interface cursor-theme Adwaita"
        "hyprctl setcursor Adwaita 24"
        "waybar"
        "swaync"
        "steam-run dlauncher"
        # "hyprswitch init --custom-css ${./hyprswitch.css}"
        "gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3"
      ];

      env = [
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland, x11"
        "QT_QPA_PLATFORM, wayland;xcb"
        "HYPRCURSOR_THEME, Adwaita"
        "HYPRCURSOR_SIZE, 24"
      ];

      input = {
        kb_layout = "us";

        follow_mouse = 2;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;

        layout = "dwindle";

        "$mod" = "SUPER";

        "col.active_border" = "rgb(2052a9)";
        "col.inactive_border" = "rgb(000000)";
      };

      dwindle = {
      };

      gestures = {
        workspace_swipe = true;
      };

      decoration = {
        rounding = 1;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = false;
        };
        shadow = {
          enabled = true;
          range = 4;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        bezier = [
          "curve, 0.22, 1, 0.36, 1"
        ];

        animation = [
          "windows, 1, 6, curve, popin 10%"
          "windowsOut, 1, 6, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 4, default"
        ];
      };

      misc = {
        focus_on_activate = true;
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
      };

      windowrulev2 = [
        "tag +file-manager, class:^(org.gnome.Nautilus)$"
        "tag +terminal, class:^(com.mitchellh.ghostty)$"
        "tag +browser, class:^(Brave-browser(-beta|-dev|-unstable)?)$"
        "tag +browser, class:^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
        "tag +editor, class:^(VSCode|code-url-handler)$"
        "tag +settings, class:^(gnome-disks|wihotspot(-gui)?)$"
        "tag +settings, class:^(file-roller|org.gnome.FileRoller)$"
        "tag +settings, class:^(nm-applet|nm-connection-editor|blueman-manager)$"
        "tag +settings, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
        "tag +settings, class:^(nwg-look|qt5ct|qt6ct|[Yy]ad)$"
        "tag +settings, class:(xdg-desktop-portal-gtk)"
        "tag +settings, class:(org.gnome.Settings)"

        "float, title:^(Picture-in-Picture)$"
        "move 72% 7%,title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "keepaspectratio, title:^(Picture-in-Picture)$"

        "float, tag:settings*"
        "float, initialTitle:(Add Folder to Workspace)"
        "float, initialTitle:(Open Files)"
        "float, initialTitle:(wants to save)"

        "size 70% 60%, initialTitle:(Open Files)"
      ];
    };
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
