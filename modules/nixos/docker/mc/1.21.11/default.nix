{ dataDir }:
{ ... }:

{
  virtualisation.arion.projects."mc-1-21-11".settings = {
    services = {
      fabric = {
        out.service.stdin_open = true;

        service = {
          container_name = "mc";
          restart = "unless-stopped";
          tty = true;
          ports = [ "25565:25565" ];

          volumes = [ "${dataDir}:/mc" ];

          build = {
            context = dataDir;
            dockerfile = "Dockerfile";
          };
        };
      };
    };
  };
}
