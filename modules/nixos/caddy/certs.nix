{ config, ... }:

{
  sops = {
    secrets."services/cf/challenge" = { };
    templates."acme-cloudflare.env".content = ''
      CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."services/cf/challenge"}
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "cert@diced.sh";
      group = "caddy";
    };

    certs = {
      "phx-diced-sh" = {
        domain = "phx.diced.sh";
        extraDomainNames = [ "*.phx.diced.sh" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = config.sops.templates."acme-cloudflare.env".path;
      };

      "sjc-diced-sh" = {
        domain = "sjc.diced.sh";
        extraDomainNames = [ "*.sjc.diced.sh" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = config.sops.templates."acme-cloudflare.env".path;
      };

      "diced-sh" = {
        domain = "diced.sh";
        extraDomainNames = [ "*.diced.sh" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = config.sops.templates."acme-cloudflare.env".path;
      };
    };
  };
}
