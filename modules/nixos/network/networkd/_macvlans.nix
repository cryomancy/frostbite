_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.macvlans;
in {
  options = {
    frostbite.networking.macvlans = {
      type = lib.types.submodule {
        options = {
        };
      };
    };
  };

  # CREATES A MACVLAN NETDEV FOR EACH CONTAINER PRESENTED AS AN INPUT
  # lib.mkIf macvlans is not {} empty
  config = lib.mkIf cfg.enable {
    systemd = {
      network = {
        # for each seperate netdev option passed create a netdev and its corresponding network?
        netdevs = {
          "25-container-macvlan" = {
            Kind = "macvlan";
            Name = "container-macvlan";
            macvlanConfig = {
              Mode = "bridge";
            };
          };
        };
      };
    };
  };
}
