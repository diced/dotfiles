{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nvf = {
      url = "github:notashelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
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
      nix-index-database,
      nvf,
      zjstatus,
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
          specialArgs = {
            inherit
              inputs
              outputs
              host
              user
              mkNeovim
              system
              ;
          };
          modules = [
            ./modules/hosts/${host}
            home-manager.nixosModules.home-manager
          ];
        };

      mkHome =
        system: host:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              host
              user
              mkNeovim
              system
              ;
            homeModules = "${self}/modules/home";
          };
          modules = [
            ./home/${host}
            nix-index-database.homeModules.nix-index
          ];
        };
    in
    {
      formatter = mkSystemPackages [ "x86_64-linux" "aarch64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
      );

      packages = mkSystemPackages [ "x86_64-linux" "aarch64-darwin" ] (system: {
        neovim = (mkNeovim system).neovim;
      });

      darwinConfigurations."macbook-pro" = mkDarwinSystem "macbook-pro";
      nixosConfigurations."nixos-vm" = mkNixosSystem "nixos-vm" "aarch64-darwin";
      nixosConfigurations."nixos-hp" = mkNixosSystem "nixos-hp" "x86_64-linux";

      homeConfigurations = {
        "macbook-pro" = mkHome "aarch64-darwin" "macbook-pro";
        "nixos-vm" = mkHome "aarch64-linux" "nixos-vm";
        "nixos-hp" = mkHome "x86_64-linux" "nixos-hp";
      };
    };
}
