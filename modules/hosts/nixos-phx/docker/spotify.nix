{ config, ... }:

{
  sops = {
    secrets = {
      spotify_public = { };
      spotify_secret = { };
    };

    templates."service.spotify.env".content = ''
      SPOTIFY_PUBLIC=${config.sops.placeholder.spotify_public}
      SPOTIFY_SECRET=${config.sops.placeholder.spotify_secret}
      API_ENDPOINT="https://spotify-srv.phx.diced.sh"
      CLIENT_ENDPOINT="https://spotify.phx.diced.sh"
    '';
  };

  virtualisation.arion.projects."spotify".settings = {
    services = {
      server = {
        service = {
          image = "yooooomi/your_spotify_server:latest";
          restart = "always";
          ports = [ "8080:8080" ];
          depends_on = [ "mongo" ];
          env_file = [
            config.sops.templates."service.spotify.env".path
          ];
        };
      };

      web = {
        service = {
          image = "yooooomi/your_spotify_client:latest";
          restart = "always";
          ports = [ "3004:3000" ];
          env_file = [
            config.sops.templates."service.spotify.env".path
          ];
        };
      };

      mongo = {
        service = {
          image = "mongo:6";
          volumes = [
            "/block/spotify/your_spotify_db:/data/db"
          ];
        };
      };
    };
  };

  services.caddy.virtualHosts = {
    "spotify-srv.phx.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:8080

      import wc-phx
    '';

    "spotify.phx.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:3004

      import wc-phx
    '';
  };
}
