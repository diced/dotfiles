{ dataDir }:
{ config, ... }:

{
  sops.secrets."services/umami/secret" = { };

  sops.templates."services.umami.env".content = ''
    APP_SECRET=${config.sops.placeholder."services/umami/secret"}
  '';

  virtualisation.arion.projects."umami".settings = {
    services = {
      umami = {
        service = {
          image = "ghcr.io/umami-software/umami:postgresql-latest";
          restart = "always";
          ports = [ "3001:3000" ];
          depends_on = [ "db" ];
          env_file = [ config.sops.templates."services.umami.env".path ];
          environment = {
            DATABASE_TYPE = "postgresql";
            DATABASE_URL = "postgresql://umami:umami@db:5432/umami";
            TZ = "America/Los_Angeles";
          };
        };
      };

      db = {
        service = {
          image = "postgres:15-alpine";
          restart = "always";
          environment = {
            POSTGRES_DB = "umami";
            POSTGRES_USER = "umami";
            POSTGRES_PASSWORD = "umami";
          };
          volumes = [
            "${dataDir}/data:/var/lib/postgresql/data"
          ];
          healthcheck = {
            test = [
              "CMD-SHELL"
              "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"
            ];
            interval = "5s";
            timeout = "5s";
            retries = 5;
          };
        };
      };
    };
  };

  systemd.services."arion-umami" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts."http://analytics_.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:3001
  '';
}
