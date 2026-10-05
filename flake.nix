{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nvf = {
      url = "github:notashelf/nvf/main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nix-homebrew,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      nvf,
      disko,
      arion,
      sops,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      user = "diced";

      mkSystemPackages =
        systems: f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f system;
          }) systems
        );

      mkNeovim =
        system:
        nvf.lib.neovimConfiguration {
          pkgs = import nixpkgs-unstable {
            inherit system;
          };

          modules = [
            ./modules/nvf
          ];
        };

      mkDarwinSystem =
        host:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit
              inputs
              outputs
              host
              user
              ;
          };
          modules = [
            ./modules/hosts/${host}
            home-manager.darwinModules.home-manager
            ./modules/home/home-manager.nix
            nix-homebrew.darwinModules.nix-homebrew

            {
              nix-homebrew = {
                inherit user;

                enable = true;
                enableRosetta = true;
              };
            }
          ];
        };

      mkNixosSystem =
        host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              outputs
              host
              user
              ;
          };
          modules = [
            ./modules/hosts/${host}
            home-manager.nixosModules.home-manager
            ./modules/home/home-manager.nix
          ];
        };

      mkNixosVPS =
        host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              user
              outputs
              host
              ;
            nixosModules = "${self}/modules/nixos";
          };

          modules = [
            ./modules/hosts/${host}
            home-manager.nixosModules.home-manager
            ./modules/home/home-manager.nix
            disko.nixosModules.disko
            arion.nixosModules.arion
            sops.nixosModules.sops
          ];
        };
    in
    {
      formatter = mkSystemPackages [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt
      );

      packages = mkSystemPackages [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (system: {
        inherit ((mkNeovim system)) neovim;
      });

      # personal configs
      darwinConfigurations."macbook-pro" = mkDarwinSystem "macbook-pro";
      nixosConfigurations = {
        "nixos-vm" = mkNixosSystem "nixos-vm" "aarch64-linux";
        "nixos-hp" = mkNixosSystem "nixos-hp" "x86_64-linux";

        "nixos-phx" = mkNixosVPS "nixos-phx" "aarch64-linux";
        "nixos-sjc" = mkNixosVPS "nixos-sjc" "aarch64-linux";
      };
    };
}
