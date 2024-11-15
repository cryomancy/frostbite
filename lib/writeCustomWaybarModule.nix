{
  helperFunction,
  pkgs,
}: let
  inherit helperFunction pkgs;
  # Function that creates a custom Waybar Module
  writeCustomWaybarModule = {
    dependencies ? [],
    script ? "",
    text ? "",
    tooltip ? "",
    alt ? "",
    class ? "",
    percentage ? "",
  }:
    helperFunction {
      name = "customWaybarModule";
      dependencies = [pkgs.jq] ++ dependencies;
      script = ''
        ${script}
        jq -cn \
          --arg text "${text}" \
          --arg tooltip "${tooltip}" \
          --arg alt "${alt}" \
          --arg class "${class}" \
          --arg percentage "${percentage}" \
          '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
      '';
    };
in
  writeCustomWaybarModule
