{
  nixosModules,
  ...
}:

{
  imports = [
    "${nixosModules}/docker"

    (import "${nixosModules}/docker/media.nix" { dataDir = "/block/media"; })
    (import "${nixosModules}/docker/yamtrack.nix" { dataDir = "/block/yamtrack"; })
    (import "${nixosModules}/docker/vaultwarden.nix" { dataDir = "/block/vaultwarden"; })
  ];
}
