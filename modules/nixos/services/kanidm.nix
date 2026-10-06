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
        groups.radarr_users.overwriteMembers = false;
        groups.prowlarr_users.overwriteMembers = false;
        groups.autobrr_users.overwriteMembers = false;
        groups.zipline_users.overwriteMembers = false;

        systems.oauth2.zipline = {
          displayName = "Zipline";
          originLanding = "https://z.diced.sh";
          originUrl = "https://z.diced.sh/api/auth/oauth/oidc";
          preferShortUsername = true;
          scopeMaps.zipline_users = [
            "openid"
            "email"
            "profile"
            "offline_access"
          ];
        };

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

        systems.oauth2.radarr_whatbox = {
          displayName = "Radarr";
          originLanding = "https://radarr.box.diced.sh";
          originUrl = "https://radarr.box.diced.sh/oauth2/callback";
          scopeMaps.radarr_users = [
            "openid"
            "email"
            "profile"
          ];
        };

        systems.oauth2.prowlarr_whatbox = {
          displayName = "Prowlarr";
          originLanding = "https://prowlarr.box.diced.sh";
          originUrl = "https://prowlarr.box.diced.sh/oauth2/callback";
          scopeMaps.prowlarr_users = [
            "openid"
            "email"
            "profile"
          ];
        };

        systems.oauth2.autobrr_whatbox = {
          displayName = "autobrr";
          originLanding = "https://autobrr.box.diced.sh";
          originUrl = "https://autobrr.box.diced.sh/api/auth/oidc/callback";
          scopeMaps.autobrr_users = [
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
