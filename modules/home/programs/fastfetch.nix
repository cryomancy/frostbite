_:
{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.frostbite.programs.fastfetch;
in
{
  options = {
    frostbite.programs.fastfetch = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;

      settings = {
        logo = {
          type = "builtin";
          source = "NixOS";
        };

        display = {
          color = {
            keys = "blue";
            title = "blue";
          };
        };

        modules = [
          "title"
          "separator"
          {
            type = "os";
            key = "Distro";
            format = "{3}";
          }
          {
            type = "kernel";
            key = "Kernel Version";
            format = "{2}";
          }
          {
            type = "packages";
            format = "{9}";
          }
          "shell"
          "wm"
          "separator"
          {
            type = "cpu";
            format = "{1} - {3} Cores";
          }
          {
            type = "gpu";
            key = "GPU";
            hideType = "integrated";
            format = "{2}";
          }
          {
            type = "memory";
          }
          {
            type = "disk";
          }
        ];
      };
    };
  };
}
