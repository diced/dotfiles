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

    (
      self: prev:
      let
        version = "0.7.5";
      in
      {
        fladder = prev.stdenv.mkDerivation {
          pname = "fladder";
          inherit version;

          src = prev.fetchurl {
            url = "https://github.com/DonutWare/Fladder/releases/download/v${version}/Fladder-macOS-${version}.dmg";
            sha256 = "sha256-RqOBBUvX+Tqp/b7dU1+OEhgVvpEyZKqxGfuyyXGgM6U=";
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
            description = "Fladder - A Simple Jellyfin frontend built on top of Flutter.";
            homepage = "https://github.com/DonutWare/Fladder";
            license = licenses.gpl3;
            platforms = platforms.darwin;
          };
        };
      }
    )
  ];
}
