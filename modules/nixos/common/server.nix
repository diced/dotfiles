{
  user,
  pkgs,
  host,
  ...
}:

{
  imports = [
    ./nixos.nix
    ../scripts/ad.nix
    ../iscsi.nix
    ../caddy
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = [
      "wheel"
      "acme"
      "docker"
      "caddy"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBP5NwXTLHvv0ysxlxpf15OxMydlScfW78NKUJfr8r8 diced@macbook-pro"
    ];

    shell = pkgs.zsh;
  };

  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    # pin kernel to lts 6.18
    kernelPackages = pkgs.linuxPackages_6_18;
  };

  programs.zsh.enable = true;

  networking.hostName = host;

  time.timeZone = "America/Los_Angeles";

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services = {
    openssh.enable = true;

    tailscale = {
      enable = true;
      openFirewall = true;
      extraUpFlags = [ "--ssh" ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    htop
    neovim
  ];
}
