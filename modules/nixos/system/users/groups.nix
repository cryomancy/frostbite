_: {
  config,
  lib,
  users,
  ...
}: let
  cfg = config.frostbite.users;
in {
  config = lib.mkIf cfg.enable {
    users = {
      groups =
        lib.genAttrs (lib.attrsets.attrNames cfg.users) # Retrieve all usernames
        
        (user: {${user} = {};});
    };
  };
}
