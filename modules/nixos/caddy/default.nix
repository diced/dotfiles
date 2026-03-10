{ ... }:

{
  imports = [
    ./certs.nix
  ];

  services.caddy = {
    enable = true;
    group = "caddy";

    # sets up ssl for hosts that "include wc-phx"
    extraConfig = ''
      (wc-phx) {
        tls /var/lib/acme/phx-diced-sh/cert.pem /var/lib/acme/phx-diced-sh/key.pem {
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
