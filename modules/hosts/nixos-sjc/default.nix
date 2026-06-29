{
  nixosModules,
  ...
}:
{
  imports = [
    ./disko.nix
    ./hw.nix
    ./docker.nix

    "${nixosModules}/common/server.nix"
  ];

  sops = {
    defaultSopsFile = ../../secrets/nixos-sjc.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    # secrets are defined where they are used.
  };

  system.stateVersion = "26.05";
}
