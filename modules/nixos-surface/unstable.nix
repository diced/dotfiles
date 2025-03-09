{ self, ... }:

{
  nixpkgs.overlays = with self.inputs; [
    (final: prev: {
      unstable = import nixpkgs-unstable { inherit (prev) config system; };
    })
  ];
}