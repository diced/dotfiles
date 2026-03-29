{
  nixosModules,
  ...
}:

{
  imports = [
    "${nixosModules}/docker"

    (import "${nixosModules}/docker/spotify.nix" { dataDir = "/block/spotify"; })
    (import "${nixosModules}/docker/umami.nix" { dataDir = "/block/umami"; })
    (import "${nixosModules}/docker/mc/1.21.11" { dataDir = "/block/mc-1.21.11"; })
    (import "${nixosModules}/docker/zipline.nix" { dataDir = "/block/zipline4"; })
  ];
}
