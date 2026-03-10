{ dataDir }:
{ config, ... }:

{
  sops = {
    secrets = {
      "services/zipline/secret" = { };
      "services/zipline/pg_password" = { };
    };

    templates."services.zipline.env".content = ''
      POSTGRES_PASSWORD=${config.sops.placeholder."services/zipline/pg_password"}
      DATABASE_URL=postgres://zipline:${
        config.sops.placeholder."services/zipline/pg_password"
      }@postgresql:5432/zipline
      CORE_SECRET=${config.sops.placeholder."services/zipline/secret"}
    '';
  };

  virtualisation.arion.projects."zipline".settings = {
    services = {
      postgresql = {
        service = {
          image = "postgres:16";
          restart = "unless-stopped";
          env_file = [ config.sops.templates."services.zipline.env".path ];
          environment = {
            POSTGRES_USER = "zipline";
            POSTGRES_DB = "zipline";
          };
          volumes = [
            "${dataDir}/pgdata:/var/lib/postgresql/data"
          ];
          healthcheck = {
            test = [
              "CMD"
              "pg_isready"
              "-U"
              "zipline"
            ];
            interval = "10s";
            timeout = "5s";
            retries = 5;
          };
        };
      };

      zipline = {
        service = {
          image = "ghcr.io/diced/zipline:v4";
          restart = "unless-stopped";
          ports = [ "3002:3000" ];
          depends_on = [ "postgresql" ];
          env_file = [ config.sops.templates."services.zipline.env".path ];
          volumes = [
            "${dataDir}/uploads:/zipline/uploads"
            "${dataDir}/public:/zipline/public"
            "${dataDir}/themes:/zipline/themes"
          ];
          healthcheck = {
            test = [
              "CMD"
              "wget"
              "-q"
              "--spider"
              "http://0.0.0.0:3000/api/healthcheck"
            ];
            interval = "15s";
            timeout = "2s";
            retries = 2;
          };
        };
      };
    };
  };

  systemd.services."arion-zipline" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };
}
