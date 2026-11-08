{ dataDir }:
{ config, pkgs, ... }:

{
  sops = {
    secrets = {
      "services/wakapi/password_salt" = { };
      "services/wakapi/cookie_key" = { };
      "services/wakapi/oidc_client_secret" = { };
    };

    templates."services.wakapi.env" = {
      content = ''
        WAKAPI_PASSWORD_SALT=${config.sops.placeholder."services/wakapi/password_salt"}
        WAKAPI_COOKIE_KEY=${config.sops.placeholder."services/wakapi/cookie_key"}
        WAKAPI_OIDC_PROVIDERS_0_CLIENT_SECRET=${
          config.sops.placeholder."services/wakapi/oidc_client_secret"
        }
      '';
      restartUnits = [ "arion-wakapi.service" ];
    };
  };

  virtualisation.arion.projects.wakapi.settings.services.wakapi = {
    out.service.init = true;
    service = {
      image = "ghcr.io/muety/wakapi:latest";
      restart = "unless-stopped";
      user = "65532:65532";
      ports = [ "127.0.0.1:3040:3000" ];
      volumes = [ "${dataDir}/data:/data" ];
      env_file = [ config.sops.templates."services.wakapi.env".path ];
      environment = {
        ENVIRONMENT = "prod";
        TZ = "America/Los_Angeles";
        WAKAPI_LISTEN_IPV4 = "0.0.0.0";
        WAKAPI_LISTEN_IPV6 = "-";
        WAKAPI_PORT = "3000";
        WAKAPI_PUBLIC_URL = "https://wakapi.diced.sh";
        WAKAPI_DB_TYPE = "sqlite3";
        WAKAPI_DB_NAME = "/data/wakapi.db";
        WAKAPI_INSECURE_COOKIES = "false";
        WAKAPI_MAIL_ENABLED = "false";

        # Kanidm controls who may register; editor clients still use API keys.
        WAKAPI_DISABLE_LOCAL_AUTH = "true";
        WAKAPI_ALLOW_SIGNUP = "false";
        WAKAPI_INVITE_CODES = "false";
        WAKAPI_OIDC_ALLOW_SIGNUP = "true";
        WAKAPI_OIDC_PROVIDERS_0_NAME = "kanidm";
        WAKAPI_OIDC_PROVIDERS_0_DISPLAY_NAME = "Kanidm";
        WAKAPI_OIDC_PROVIDERS_0_CLIENT_ID = "wakapi";
        WAKAPI_OIDC_PROVIDERS_0_ENDPOINT = "https://idm.diced.sh/oauth2/openid/wakapi";
      };
    };
  };

  systemd.services.arion-wakapi = {
    after = [
      "iscsi-oracle-login.service"
      "kanidm.service"
    ];
    requires = [ "iscsi-oracle-login.service" ];
    wants = [ "kanidm.service" ];
    # Create the bind mount with the upstream image's non-root UID after /block mounts.
    preStart = ''
      ${pkgs.coreutils}/bin/install -d -m 0750 -o 65532 -g 65532 ${dataDir}/data
    '';
  };

  services.caddy.virtualHosts."http://wakapi.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:3040 {
      header_up X-Forwarded-Proto https
    }
  '';
}
