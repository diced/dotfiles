{ config, pkgs, ... }:

{
  sops.secrets."services/kanidm/idm_admin_password" = {
    owner = "kanidm";
    restartUnits = [ "kanidm.service" ];
  };

  services = {
    kanidm = {
      package = pkgs.kanidm_1_11.withSecretProvisioning;

      server = {
        enable = true;

        settings = {
          domain = "idm.diced.sh";
          origin = "https://idm.diced.sh";

          bindaddress = "127.0.0.1:8443";

          tls_chain = "/var/lib/acme/diced-sh/fullchain.pem";
          tls_key = "/var/lib/acme/diced-sh/key.pem";
        };
      };

      client = {
        enable = true;

        settings.uri = "https://idm.diced.sh";
      };

      provision = {
        enable = true;
        autoRemove = false;
        idmAdminPasswordFile = config.sops.secrets."services/kanidm/idm_admin_password".path;

        groups.sonarr_users.overwriteMembers = false;

        systems.oauth2.sonarr_whatbox = {
          displayName = "Sonarr";
          originLanding = "https://sonarr.box.diced.sh";
          originUrl = "https://sonarr.box.diced.sh/oauth2/callback";
          scopeMaps.sonarr_users = [
            "openid"
            "email"
            "profile"
          ];
        };
      };
    };

    caddy.virtualHosts."idm.diced.sh".extraConfig = ''
      tls /var/lib/acme/diced-sh/fullchain.pem /var/lib/acme/diced-sh/key.pem

      reverse_proxy 127.0.0.1:8443 {
        header_up Host idm.diced.sh

        transport http {
          tls
          tls_server_name idm.diced.sh
        }
      }
    '';
  };

  users.users.kanidm.extraGroups = [ "caddy" ];

  security.acme.certs."diced-sh".reloadServices = [
    "kanidm.service"
  ];
}
