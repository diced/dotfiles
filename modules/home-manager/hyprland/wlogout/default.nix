{ lib, config, ... }:

{
  options.cfg.hyprland.wlogout = lib.mkOption {
    type = lib.types.bool;
    default = config.cfg.hyprland.enable;
  };

  config = lib.mkIf config.cfg.hyprland.wlogout {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit 0";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
      ];
      style = ''
        window {
          font-family: Cantarell;
          font-size: 14pt;
          color: #ffffff;
          background-color: rgba(0, 0, 0, 0.75);
        }

        button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          border: none;
          background-color: rgba(0, 0, 0, 0);
          margin: 5px;
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
          color: #ffffff;
        }

        button:hover {
          background-color:rgb(36, 103, 218);
        }

        button:focus {
          background-color: #2052a9;
        }

        #lock {
          background-image: image(url("${./lock.png}"));
        }
        #lock:hover {
          background-image: image(url("${./lock-hover.png}"));
        }

        #reboot {
          background-image: image(url("${./reboot.png}"));
        }
        #reboot:hover {
          background-image: image(url("${./reboot-hover.png}"));
        }

        #shutdown {
          background-image: image(url("${./shutdown.png}"));
        }
        #shutdown:hover {
          background-image: image(url("${./shutdown-hover.png}"));
        }

        #suspend {
          background-image: image(url("${./suspend.png}"));
        }
        #suspend:hover {
          background-image: image(url("${./suspend-hover.png}"));
        }

        #logout {
          background-image: image(url("${./logout.png}"));
        }
        #logout:hover {
          background-image: image(url("${./logout-hover.png}"));
        }
      '';
    };
  };
}