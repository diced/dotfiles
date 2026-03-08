{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics.enable = true;

    nvidia = {
      open = false;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;

        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:6@0:0:0";
      };
    };
  };

  programs = {
    gamescope.enable = true;
    gamemode.enable = true;
  };
}
