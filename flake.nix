{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

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
  };

  outputs =
    {
      self,
      nix-darwin,
      nix-homebrew,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      nix-index-database,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # Function for nix-darwin system configuration
      mkDarwinConfiguration =
        hostname: username:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs hostname;
          };
          modules = [
            ./modules/hosts/${hostname}
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew

            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "diced";
              };
            }
          ];
        };

      mkNixosConfiguration =
        hostname: username:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs hostname;
          };
          modules = [
            ./modules/hosts/${hostname}
          ];
        };

      # Function for Home Manager configuration
      mkHomeConfiguration =
        system: username: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit inputs outputs;
            homeModules = "${self}/modules/home";
          };
          modules = [
            ./home/${hostname}
            nix-index-database.homeModules.nix-index
          ];
        };
    in
    {
      darwinConfigurations."macbook-pro" = mkDarwinConfiguration "macbook-pro" "diced";
      nixosConfigurations."nixos-vm" = mkNixosConfiguration "nixos-vm" "diced";

      homeConfigurations."macbook-pro" = mkHomeConfiguration "aarch64-darwin" "diced" "macbook-pro";
      homeConfigurations."nixos-vm" = mkHomeConfiguration "aarch64-linux" "diced" "nixos-vm";
    };
}
