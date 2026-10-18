{ dataDir }:
{ config, ... }:

{
  sops = {
    secrets = {
      "services/weblate/pg_password" = { };
      "services/weblate/admin_password" = { };
      "services/weblate/github_client_id" = { };
      "services/weblate/github_client_secret" = { };
    };

    templates."services.weblate.database.env" = {
      content = ''
        POSTGRES_PASSWORD=${config.sops.placeholder."services/weblate/pg_password"}
      '';
      restartUnits = [ "arion-weblate.service" ];
    };

    templates."services.weblate.env" = {
      content = ''
        WEBLATE_ADMIN_PASSWORD=${config.sops.placeholder."services/weblate/admin_password"}
        WEBLATE_SOCIAL_AUTH_GITHUB_KEY=${config.sops.placeholder."services/weblate/github_client_id"}
        WEBLATE_SOCIAL_AUTH_GITHUB_SECRET=${config.sops.placeholder."services/weblate/github_client_secret"}
      '';
      restartUnits = [ "arion-weblate.service" ];
    };
  };

  virtualisation.arion.projects.weblate.settings = {
    services = {
      database.service = {
        image = "postgres:17-alpine";
        restart = "unless-stopped";
        env_file = [ config.sops.templates."services.weblate.database.env".path ];
        environment = {
          POSTGRES_USER = "weblate";
          POSTGRES_DB = "weblate";
        };
        volumes = [ "${dataDir}/postgres:/var/lib/postgresql/data" ];
        healthcheck = {
          test = [
            "CMD"
            "pg_isready"
            "-U"
            "weblate"
            "-d"
            "weblate"
          ];
          interval = "10s";
          timeout = "5s";
          retries = 5;
        };
      };

      cache.service = {
        image = "valkey/valkey:8-alpine";
        restart = "unless-stopped";
        command = [
          "valkey-server"
          "--save"
          "60"
          "1"
          "--loglevel"
          "warning"
        ];
        volumes = [ "${dataDir}/valkey:/data" ];
        healthcheck = {
          test = [
            "CMD"
            "valkey-cli"
            "ping"
          ];
          interval = "10s";
          timeout = "5s";
          retries = 5;
        };
      };

      weblate = {
        service = {
          image = "weblate/weblate:latest";
          restart = "unless-stopped";
          ports = [ "127.0.0.1:8090:8080" ];
          depends_on = {
            database.condition = "service_healthy";
            cache.condition = "service_healthy";
          };
          volumes = [
            "${dataDir}/data:/app/data"
            "${dataDir}/cache:/app/cache"
          ];
          env_file = [
            config.sops.templates."services.weblate.database.env".path
            config.sops.templates."services.weblate.env".path
          ];
          environment = {
            POSTGRES_HOST = "database";
            POSTGRES_PORT = "5432";
            POSTGRES_USER = "weblate";
            POSTGRES_DB = "weblate";
            REDIS_HOST = "cache";
            REDIS_PORT = "6379";

            WEBLATE_SITE_TITLE = "Zipline Weblate";
            WEBLATE_SITE_DOMAIN = "wl.diced.sh";
            WEBLATE_ALLOWED_HOSTS = "wl.diced.sh";
            WEBLATE_ADMIN_NAME = "diced";
            WEBLATE_ADMIN_EMAIL = "me@diced.sh";

            WEBLATE_GPG_IDENTITY = "Weblate <weblate@diced.sh>";
            WEBLATE_DEFAULT_COMMITER_NAME = "Weblate";
            WEBLATE_DEFAULT_COMMITER_EMAIL = "weblate@diced.sh";

            # disabling email but allowing github signup
            WEBLATE_REGISTRATION_OPEN = "1";
            WEBLATE_NO_EMAIL_AUTH = "1";

            WEBLATE_ENABLE_HTTPS = "1";
            WEBLATE_SECURE_PROXY_SSL_HEADER = "HTTP_X_FORWARDED_PROTO,https";
            WEBLATE_TIME_ZONE = "America/Los_Angeles";
            TZ = "America/Los_Angeles";
          };
        };
      };
    };
  };

  systemd.services."arion-weblate" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts."http://wl.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:8090 {
      header_up X-Forwarded-Proto https
    }
  '';
}
