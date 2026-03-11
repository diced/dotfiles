{ ... }:

{
  imports = [
    ./certs.nix
  ];

  services.caddy = {
    enable = true;
    group = "caddy";

    # sets up ssl for hosts that "include wc-phx" or "include wc-sjc"
    extraConfig = ''
      (wc-phx) {
        tls /var/lib/acme/phx-diced-sh/cert.pem /var/lib/acme/phx-diced-sh/key.pem {
          protocols tls1.3
        }
      }

      (wc-sjc) {
        tls /var/lib/acme/sjc-diced-sh/cert.pem /var/lib/acme/sjc-diced-sh/key.pem {
          protocols tls1.3
        }
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
