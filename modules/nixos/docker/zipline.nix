{ dataDir }:
{ config, ... }:

{
  sops = {
    secrets = {
      "services/zipline/secret" = { };
      "services/zipline/pg_password" = { };
      "services/zipline/oidc_client_secret" = { };
    };

    templates."services.zipline.env".content = ''
      POSTGRES_PASSWORD=${config.sops.placeholder."services/zipline/pg_password"}
      DATABASE_URL=postgres://zipline:${
        config.sops.placeholder."services/zipline/pg_password"
      }@postgresql:5432/zipline
      CORE_SECRET=${config.sops.placeholder."services/zipline/secret"}
    '';

    templates."services.zipline.oidc.env" = {
      content = ''
        OAUTH_OIDC_CLIENT_SECRET=${config.sops.placeholder."services/zipline/oidc_client_secret"}
      '';
      restartUnits = [ "arion-zipline.service" ];
    };
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
          image = "ghcr.io/diced/zipline:latest";
          restart = "unless-stopped";
          ports = [ "3002:3000" ];
          depends_on = [ "postgresql" ];

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

          env_file = [
            config.sops.templates."services.zipline.env".path
            config.sops.templates."services.zipline.oidc.env".path
          ];
          environment = {
            TZ = "America/Los_Angeles";
            CORE_RETURN_HTTPS_URLS = "true";
            FEATURES_OAUTH_REGISTRATION = "true";

            OAUTH_LOGIN_ONLY = "true";
            OAUTH_BYPASS_LOCAL_LOGIN = "true";
            OAUTH_OIDC_CLIENT_ID = "zipline";
            OAUTH_OIDC_AUTHORIZE_URL = "https://idm.diced.sh/ui/oauth2";
            OAUTH_OIDC_TOKEN_URL = "https://idm.diced.sh/oauth2/token";
            OAUTH_OIDC_USERINFO_URL = "https://idm.diced.sh/oauth2/openid/zipline/userinfo";
            OAUTH_OIDC_REDIRECT_URI = "https://z.diced.sh/api/auth/oauth/oidc";
          };
        };
      };
    };
  };

  systemd.services."arion-zipline" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts."http://z.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:3002
  '';
}
