{ dataDir }:
{ config, ... }:

{
  sops = {
    secrets = {
      "services/komodo/db_password" = { };
      "services/komodo/jwt_secret" = { };
      "services/komodo/webhook_secret" = { };
      "services/komodo/oidc_client_secret" = { };
    };

    templates."services.komodo.mongo.env" = {
      content = ''
        MONGO_INITDB_ROOT_PASSWORD=${config.sops.placeholder."services/komodo/db_password"}
      '';
      restartUnits = [ "arion-komodo.service" ];
    };

    templates."services.komodo.core.env" = {
      content = ''
        KOMODO_DATABASE_PASSWORD=${config.sops.placeholder."services/komodo/db_password"}
        KOMODO_JWT_SECRET=${config.sops.placeholder."services/komodo/jwt_secret"}
        KOMODO_WEBHOOK_SECRET=${config.sops.placeholder."services/komodo/webhook_secret"}
        KOMODO_OIDC_CLIENT_SECRET=${config.sops.placeholder."services/komodo/oidc_client_secret"}
      '';
      restartUnits = [ "arion-komodo.service" ];
    };
  };

  virtualisation.arion.projects."komodo".settings.services = {
    mongo.service = {
      image = "mongo:7";
      restart = "unless-stopped";
      labels."komodo.skip" = "";
      command = [
        "--quiet"
        "--wiredTigerCacheSizeGB"
        "0.25"
      ];
      environment.MONGO_INITDB_ROOT_USERNAME = "komodo";
      env_file = [ config.sops.templates."services.komodo.mongo.env".path ];
      volumes = [
        "${dataDir}/mongo/data:/data/db"
        "${dataDir}/mongo/config:/data/configdb"
      ];
    };

    core.out.service.init = true;
    core.service = {
      image = "ghcr.io/moghtech/komodo-core:2";
      restart = "unless-stopped";
      labels."komodo.skip" = "";
      depends_on = [ "mongo" ];
      ports = [ "127.0.0.1:9120:9120" ];
      env_file = [ config.sops.templates."services.komodo.core.env".path ];
      environment = {
        TZ = "America/Los_Angeles";
        KOMODO_HOST = "https://komodo.diced.sh";
        KOMODO_TITLE = "Komodo";
        KOMODO_DATABASE_ADDRESS = "mongo:27017";
        KOMODO_DATABASE_USERNAME = "komodo";
        KOMODO_FIRST_SERVER_NAME = "nixos-phx";
        KOMODO_PERIPHERY_PUBLIC_KEY = "file:/config/keys/periphery.pub";

        KOMODO_LOCAL_AUTH = "false";

        KOMODO_DISABLE_USER_REGISTRATION = "true";
        KOMODO_ENABLE_NEW_USERS = "false";
        KOMODO_OIDC_ENABLED = "true";
        KOMODO_OIDC_PROVIDER = "https://idm.diced.sh/oauth2/openid/komodo";
        KOMODO_OIDC_CLIENT_ID = "komodo";
        KOMODO_OIDC_USE_FULL_EMAIL = "true";
        KOMODO_OIDC_AUTO_REDIRECT = "true";
      };
      volumes = [
        "${dataDir}/keys:/config/keys"
        "${dataDir}/backups:/backups"
      ];
    };

    periphery.out.service.init = true;
    periphery.service = {
      image = "ghcr.io/moghtech/komodo-periphery:2";
      restart = "unless-stopped";
      labels."komodo.skip" = "";
      depends_on = [ "core" ];
      environment = {
        TZ = "America/Los_Angeles";
        PERIPHERY_CORE_ADDRESS = "ws://core:9120";
        PERIPHERY_CONNECT_AS = "nixos-phx";
        PERIPHERY_CORE_PUBLIC_KEYS = "file:/config/keys/core.pub";
        PERIPHERY_ROOT_DIRECTORY = "${dataDir}/periphery";
        PERIPHERY_INCLUDE_DISK_MOUNTS = "/etc/hostname";
      };
      volumes = [
        "${dataDir}/keys:/config/keys"
        "/var/run/docker.sock:/var/run/docker.sock"
        "/proc:/proc:ro"
        "${dataDir}/periphery:${dataDir}/periphery"
      ];
    };
  };

  systemd.services."arion-komodo" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts."http://komodo.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:9120
  '';
}
