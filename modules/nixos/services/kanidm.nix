{ pkgs, ... }:

{
  services = {
    kanidm = {
      package = pkgs.kanidm_1_11;

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
