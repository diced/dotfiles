{
  inputs,
  outputs,
  host,
  user,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "hm-backup";

    extraSpecialArgs = {
      inherit
        inputs
        outputs
        host
        user
        ;
      homeModules = "${inputs.self}/modules/home";
    };

    sharedModules = [ inputs.nix-index-database.homeModules.nix-index ];
    users.${user} = ../hosts/${host}/home.nix;
  };
}
