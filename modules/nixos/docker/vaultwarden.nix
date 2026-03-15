{ dataDir }:
{ config, ... }:

{
  virtualisation.arion.projects."vaultwarden".settings = {
    services.vaultwarden = {
      service = {
        image = "vaultwarden/server:latest";
        restart = "unless-stopped";
        environment = {
          DOMAIN = "https://vw.diced.sh";
        };
        volumes = [
          "${dataDir}/data:/data"
        ];
        ports = [
          "8001:80"
        ];
      };
    };
  };

  systemd.services."arion-vaultwarden" = {
    after = [
      "iscsi-oracle-login.service"
    ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts."http://vw.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:8001
  '';
}
