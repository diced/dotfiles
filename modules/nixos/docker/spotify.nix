{ dataDir }:
{ config, ... }:

{
  sops = {
    secrets = {
      "services/spotify/public" = { };
      "services/spotify/secret" = { };
    };

    templates."services.spotify.env".content = ''
      SPOTIFY_PUBLIC=${config.sops.placeholder."services/spotify/public"}
      SPOTIFY_SECRET=${config.sops.placeholder."services/spotify/secret"}
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
            config.sops.templates."services.spotify.env".path
          ];
        };
      };

      web = {
        service = {
          image = "yooooomi/your_spotify_client:latest";
          restart = "always";
          ports = [ "3004:3000" ];
          env_file = [
            config.sops.templates."services.spotify.env".path
          ];
        };
      };

      mongo = {
        service = {
          image = "mongo:6";
          volumes = [
            "${dataDir}/your_spotify_db:/data/db"
          ];
        };
      };
    };
  };

  systemd.services."arion-spotify" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
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
