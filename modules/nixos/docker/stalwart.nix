{ dataDir }:
_:

{
  virtualisation.arion.projects."stalwart".settings = {
    services = {
      stalwart.service = {
        image = "stalwartlabs/stalwart:v0.15.5";
        restart = "unless-stopped";

        ports = [
          "8080:8080"
          "25:25"
          "465:465"
          "993:993"
          "995:995"
        ];

        volumes = [
          "${dataDir}:/opt/stalwart"
        ];

        environment = {
          TZ = "America/Los_Angeles";
        };
      };
    };
  };

  systemd.services."arion-stalwart" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts = {
    "mail.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:8080 {
        header_up Host {upstream_hostport}
        header_up X-Forwarded-Proto {scheme}
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [
    25
    465
    993
    995
  ];
}
