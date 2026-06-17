{ dataDir }:
{ config, ... }:

{
  sops = {
    secrets = {
      "services/dokploy/better_auth_secret" = { };
    };

    templates."services.dokploy.env".content = ''
      BETTER_AUTH_SECRET=${config.sops.placeholder."services/dokploy/better_auth_secret"}
    '';
  };

  virtualisation.arion.projects."dokploy".settings = {
    networks = {
      dokploy-network = {
        name = "dokploy-network";
        driver = "overlay";
        attachable = true;
      };
    };

    services = {
      dokploy-postgres.service = {
        image = "postgres:16";
        restart = "unless-stopped";
        networks = [ "dokploy-network" ];
        environment = {
          POSTGRES_USER = "dokploy";
          POSTGRES_PASSWORD = "dokploy";
          POSTGRES_DB = "dokploy";
        };
        volumes = [
          "${dataDir}/postgres:/var/lib/postgresql/data"
        ];
      };

      dokploy-redis.service = {
        image = "redis:7";
        restart = "unless-stopped";
        networks = [ "dokploy-network" ];
        volumes = [
          "${dataDir}/redis:/data"
        ];
      };

      dokploy-traefik.service = {
        image = "traefik:v3.6.7";
        restart = "unless-stopped";
        networks = [ "dokploy-network" ];

        ports = [
          "8000:80"
          # "4443:443"
          # "4443:443/udp"
        ];

        volumes = [
          "${dataDir}/traefik/traefik.yml:/etc/traefik/traefik.yml"
          "${dataDir}/traefik/dynamic:/etc/dokploy/traefik/dynamic"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
      };

      dokploy.service = {
        image = "dokploy/dokploy:latest";
        restart = "unless-stopped";
        networks = [ "dokploy-network" ];

        ports = [
          "3006:3000"
        ];

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "${dataDir}:/etc/dokploy"
        ];

        environment = {
          DATABASE_URL = "postgresql://dokploy:dokploy@dokploy-postgres:5432/dokploy";
          REDIS_URL = "redis://dokploy-redis:6379/0";
          BETTER_AUTH_TRUSTED_ORIGINS = "https://dokploy.diced.sh";
        };

        env_file = [
          config.sops.templates."services.dokploy.env".path
        ];
      };
    };
  };

  systemd.services."arion-dokploy" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts = {
    "http://dokploy.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:3006
    '';

    "http://zipline-preview.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:8000
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
