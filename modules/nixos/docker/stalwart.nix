{ dataDir }:
_:

{
  virtualisation.arion.projects."stalwart".settings = {
    services = {
      stalwart.service = {
        image = "stalwartlabs/stalwart:latest";
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
      };

      # jmap-webmail.service = {
      #   image = "ghcr.io/bulwarkmail/webmail:latest";
      #   restart = "unless-stopped";
      #
      #   ports = [
      #     "3006:3000"
      #   ];
      #
      #   environment = {
      #     JMAP_SERVER_URL = "https://mail.diced.sh/";
      #   };
      # };
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

    # "wm.sjc.diced.sh".extraConfig = ''
    #   reverse_proxy 127.0.0.1:3006
    #
    #   import wc-sjc
    # '';
  };

  networking.firewall.allowedTCPPorts = [
    25
    465
    993
    995
  ];
}
