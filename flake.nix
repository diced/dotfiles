{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nix-darwin,
      nix-homebrew,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
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
            home-manager.nixosModules.home-manager
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
          ];
        };
    in
    {
      darwinConfigurations."macbook-pro" = mkDarwinConfiguration "macbook-pro" "diced";

      nixosConfigurations."nixos-vm" = mkNixosConfiguration "nixos-vm" "diced";

      homeConfigurations."macbook-pro" = mkHomeConfiguration "aarch64-darwin" "diced" "macbook-pro";
    };
}
