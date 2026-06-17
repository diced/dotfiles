{ dataDir }:
_:

{
  virtualisation.arion.projects."dokploy".settings = {
    networks = {
      dokploy-network = {
        name = "dokploy-network";
        driver = "overlay";
        attachable = true;
      };
    };

    services = {
      dokploy.service = {
        image = "dokploy/dokploy:latest";
        restart = "unless-stopped";

        networks = [ "dokploy-network" ];

        ports = [
          "3006:3000"
          "8000:80"
          "4443:443"
        ];

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "${dataDir}:/etc/dokploy"
        ];
      };
    };
  };

  systemd.services."arion-dokploy" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts = {
    "dokploy.diced.sh".extraConfig = ''
      reverse_proxy 127.0.0.1:3006 {
        header_up Host {upstream_hostport}
        header_up X-Forwarded-Proto {scheme}
      }
    '';

    # "*.apps.diced.sh".extraConfig = ''
    #   reverse_proxy 127.0.0.1:8000 {
    #     header_up Host {host}
    #     header_up X-Real-IP {remote_host}
    #     header_up X-Forwarded-For {remote_host}
    #     header_up X-Forwarded-Proto {scheme}
    #   }
    # '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
