{ user, ... }:

{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "@admin"
        user
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
