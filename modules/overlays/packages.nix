{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      go-10mb-video = pkgs.buildGoModule {
        pname = "10mb.video";
        version = "e5cd1ed583d6fce1e2552a91d48959f3243d341f";

        src = pkgs.fetchFromGitHub {
          owner = "ugjka";
          repo = "10mb.video";
          rev = "e5cd1ed583d6fce1e2552a91d48959f3243d341f";
          sha256 = "sha256-vYId1/sKz8DWjxbP5VmyzCEoBkSIxodgdfAsbUSdbKk=";
        };

        vendorHash = null;
        subPackages = [ "." ];
        buildInputs = with pkgs; [
          ffmpeg
          fdk-aac-encoder
        ];

        meta = with pkgs.lib; {
          description = "Fit a video into a 10mb file (Discord nitro pls?)";
          homepage = "https://github.com/ugjka/10mb.video";
          license = licenses.mit;
          maintainers = [ ];
          platforms = platforms.all;
          mainProgram = "10mb.video";
        };
      };
    })

    (self: prev: {
      fladder = prev.stdenv.mkDerivation {
        pname = "fladder-nightly";
        version = "nightly-232";

        src = prev.fetchurl {
          url = "https://github.com/DonutWare/Fladder/releases/download/nightly/Fladder-macOS-0.7.0-nightly.dmg";
          sha256 = "sha256-YLrFC6igDPXqlwelHcCIZ2GxutuUnzRH8564Yj9e+HQ=";
        };

        nativeBuildInputs = [ prev.undmg ];

        unpackPhase = ''
          undmg $src
        '';

        installPhase = ''
          mkdir -p $out/Applications
          cp -r Fladder.app $out/Applications/
        '';

        meta = with prev.lib; {
          description = "Fladder (Jellyfin client) from nightly .dmg release";
          homepage = "https://github.com/DonutWare/Fladder";
          license = licenses.gpl3;
          platforms = platforms.darwin;
        };
      };
    })
  ];
}
