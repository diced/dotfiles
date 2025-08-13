{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      ...
    }@inputs:
    let
      inherit (self) outputs;
      user = "diced";
      
      mkNeovim =
        system:
        nvf.lib.neovimConfiguration {
          pkgs = import nixpkgs-unstable {
            inherit system;
          };

          modules = [
            ./modules/nvim
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
                enable = true;
                enableRosetta = true;
                user = user;
              };
            }
          ];
        };

      mkNixosSystem =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              host
              user
              mkNeovim
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
              ;
            homeModules = "${self}/modules/home";
          };
          modules = [
            ./home/${host}
            nix-index-database.homeModules.nix-index
            {
              home.packages = [
                (mkNeovim "${system}").neovim
              ];
            }
          ];
        };
    in
    {
      packages."aarch64-darwin".neovim = (mkNeovim "aarch64-darwin").neovim;
      packages."x86_64-linux".neovim = (mkNeovim "x86_64-linux").neovim;

      darwinConfigurations."macbook-pro" = mkDarwinSystem "macbook-pro";
      nixosConfigurations."nixos-vm" = mkNixosSystem "nixos-vm";

      homeConfigurations = {
        "macbook-pro" = mkHome "aarch64-darwin" "macbook-pro";
        "nixos-vm" = mkHome "aarch64-linux" "nixos-vm";
      };
    };
}
