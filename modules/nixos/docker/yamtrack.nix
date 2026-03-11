{ dataDir }:
{ config, ... }:

{
  sops = {
    secrets."services/yamtrack/secret" = { };

    templates."services.yamtrack.env".content = ''
      SECRET=${config.sops.placeholder."services/yamtrack/secret"}
      REDIS_URL=redis://redis:6379
    '';
  };

  virtualisation.arion.projects."yamtrack".settings = {
    services = {
      yamtrack = {
        service = {
          image = "ghcr.io/fuzzygrim/yamtrack:dev";
          restart = "unless-stopped";
          depends_on = [ "redis" ];
          ports = [ "8000:8000" ];
          env_file = [ config.sops.templates."services.yamtrack.env".path ];
          environment = {
            TZ = "America/Los_Angeles";
          };
          volumes = [
            "${dataDir}/db:/yamtrack/db"
          ];
        };
      };

      redis = {
        service = {
          image = "redis:8-alpine";
          restart = "unless-stopped";
          volumes = [
            "${dataDir}/redis_data:/data"
          ];
        };
      };
    };
  };

  systemd.services."arion-yamtrack" = {
    after = [
      "iscsi-oracle-login.service"
    ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts."track.sjc.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:8000

    import wc-sjc
  '';
}
