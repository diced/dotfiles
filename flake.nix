{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprswitch.url = "github:h3rmt/hyprswitch/release";
  };

  outputs = inputs@{ self, hyprswitch, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager }: {
    nixosConfigurations = {
      nixos-surface = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
        };

        modules = [
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ./modules/nixos-surface

          {
            home-manager = {
              users.diced = {
                imports = [./modules/home-manager];

                # options for home manager, per host
                cfg = {
                  enable = true;
                  hyprland.enable = true;
                  ghostty = true;
                };
              };
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit self; };
            };
          }
        ];
      };
    };
  };
}
