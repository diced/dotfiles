{ dataDir }:
{ config, ... }:

{
  sops = {
    secrets = {
      "services/vw/smtp_host" = { };
      "services/vw/smtp_port" = { };
      "services/vw/smtp_from" = { };
      "services/vw/smtp_username" = { };
      "services/vw/smtp_password" = { };
    };

    templates."services.vw.env".content = ''
      SMTP_HOST=${config.sops.placeholder."services/vw/smtp_host"}
      SMTP_PORT=${config.sops.placeholder."services/vw/smtp_port"}
      SMTP_FROM=${config.sops.placeholder."services/vw/smtp_from"}
      SMTP_USERNAME=${config.sops.placeholder."services/vw/smtp_username"}
      SMTP_PASSWORD=${config.sops.placeholder."services/vw/smtp_password"}
      SMTP_SECURITY="force_tls"
      DOMAIN="https://vw.diced.sh"
    '';
  };

  virtualisation.arion.projects."vaultwarden".settings = {
    services.vaultwarden = {
      service = {
        image = "vaultwarden/server:latest";
        restart = "unless-stopped";

        volumes = [
          "${dataDir}/data:/data"
        ];

        ports = [
          "8001:80"
        ];

        env_file = [
          config.sops.templates."services.vw.env".path
        ];
      };
    };
  };

  systemd.services."arion-vaultwarden" = {
    after = [ "iscsi-oracle-login.service" ];
    requires = [ "iscsi-oracle-login.service" ];
  };

  services.caddy.virtualHosts."http://vw.diced.sh".extraConfig = ''
    reverse_proxy 127.0.0.1:8001
  '';
}
