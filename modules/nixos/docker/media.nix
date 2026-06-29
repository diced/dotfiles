{ dataDir }:
_:

{
  virtualisation.arion.projects."media".settings = {
    services = {
      jellyfin = {
        service = {
          image = "jellyfin/jellyfin:latest";
          restart = "unless-stopped";
          ports = [ "8096:8096" ];
          volumes = [
            "${dataDir}/jellyfin/config:/config"
            "${dataDir}/jellyfin/cache:/cache"
            "${dataDir}/jellyfin/config.json:/jellyfin/jellyfin-web/config.json"
            "${dataDir}/libraries:/libraries"
          ];
          environment = {
            TZ = "America/Los_Angeles";
          };
        };
      };

      sonarr = {
        service = {
          image = "ghcr.io/hotio/sonarr:latest";
          restart = "unless-stopped";
          ports = [ "8989:8989" ];
          user = "root";
          environment = {
            TZ = "America/Los_Angeles";
          };
          volumes = [
            "${dataDir}/sonarr/config:/config"
            "${dataDir}/libraries:/data"
            "${dataDir}/downloads:/downloads"
          ];
        };
      };

      radarr = {
        service = {
          image = "ghcr.io/hotio/radarr:latest";
          restart = "unless-stopped";
          ports = [ "7878:7878" ];
          user = "root";
          environment = {
            TZ = "America/Los_Angeles";
          };
          volumes = [
            "${dataDir}/radarr/config:/config"
            "${dataDir}/libraries:/data"
            "${dataDir}/downloads:/downloads"
          ];
        };
      };

      prowlarr = {
        service = {
          image = "ghcr.io/hotio/prowlarr:latest";
          restart = "unless-stopped";
          ports = [ "9696:9696" ];
          environment = {
            PUID = "1000";
            PGID = "1000";
            TZ = "America/Los_Angeles";
          };
          volumes = [ "${dataDir}/prowlarr/config:/config" ];
        };
      };

      qbittorrent = {
        service = {
          image = "ghcr.io/hotio/qbittorrent:latest";
          restart = "unless-stopped";
          ports = [ "8112:8112" ];
          environment = {
            PUID = "1000";
            PGID = "1000";
            TZ = "America/Los_Angeles";
            WEBUI_PORTS = "8112/tcp";
          };
          volumes = [
            "${dataDir}/qbittorrent/appdata:/config"
            "${dataDir}/downloads:/downloads"
            "${dataDir}/qbittorrent/nightwalker:/nightwalker"
          ];
        };
      };
    };
  };

  systemd.services."arion-media" = {
    after = [
      "iscsi-oracle-login.service"
    ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts = {
    "media.sjc.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:8096

      import wc-sjc
    '';
    "sonarr.sjc.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:8989

      import wc-sjc
    '';
    "radarr.sjc.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:7878

      import wc-sjc
    '';

    "prowlarr.sjc.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:9696

      import wc-sjc
    '';

    "qbittorrent.sjc.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:8112

      import wc-sjc
    '';

    "http://media.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:8096
    '';
  };
}
