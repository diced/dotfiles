{ dataDir }:
{ config }:

{
  virtualisation.arion.projects."stalwart".settings = {
    services.stalwart = {
      service = {
        image = "stalwartlabs/stalwart:latest";
        restart = "unless-stopped";
        tty = true; # Equivalent to -t

        ports = [
          "8080:8080" # Alternative HTTP
          "25:25" # SMTP
          "587:587" # SMTP Submission
          "465:465" # SMTP Over TLS
          "143:143" # IMAP
          "993:993" # IMAP Over TLS
          "4190:4190" # ManageSieve
          "110:110" # POP3
          "995:995" # POP3 Over TLS
        ];

        volumes = [
          "${dataDir}:/opt/stalwart"
        ];
      };
    };
  };

  systemd.services."arion-stalwart" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts."mail.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:8080

    import wc-diced
  '';
}
