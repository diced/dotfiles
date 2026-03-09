{ config, ... }:

{
  sops = {
    secrets.cloudflare_challenge = { };
    templates."acme-cloudflare.env".content = ''
      CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder.cloudflare_challenge}
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "cert@diced.sh";
      group = "caddy";
    };

    certs."phx-diced-sh" = {
      domain = "phx.diced.sh";
      extraDomainNames = [ "*.phx.diced.sh" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.templates."acme-cloudflare.env".path;
    };
  };
}
