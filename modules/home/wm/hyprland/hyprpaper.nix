{ ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = [
        "${../../../../wallpapers/nix-light.png}"
        "${../../../../wallpapers/nix-dark.png}"
      ];

      wallpaper = [ ", ${../../../../wallpapers/dark.png}" ];
    };
  };
}
