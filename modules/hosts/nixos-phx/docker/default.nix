{ ... }:

{
  imports = [
    ./spotify.nix
  ];

  virtualisation.arion = {
    backend = "docker";
  };
}
