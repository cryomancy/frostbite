scoped: {
  lib,
  pkgs,
}: let
  # Create a shell application using writeShellApplication
  parseMonitors = arg: index:
    pkgs.writeShellApplication {
      name = "parseMonitors";
      runtimeInputs = with pkgs; [hyprland coreutils];
      excludeShellChecks = ["SC2034" "SC2050"];
      text = ''
        monitors=$(hyprctl monitors all | grep Monitor | awk 'END {print NR}')
        monitorNames=$(hyprctl monitors all | grep Monitor | awk '{print $2}')
        resolutions=$(hyprctl monitors all | grep ' at ' | awk '{print $1}')
        positions=$(hyprctl monitors all | grep ' at ' | awk '{print $3}')
        scales=$(hyprctl monitors all | grep 'scale' | awk '{print $2}')
        monitorData=()

        for i in $(seq 0 "$monitors" - 1); do
          monitorData[i]=$(echo "$monitorNames $resolutions $positions $scales" | cut -d' ' -f"$(i + 1)")
        done

        if [ "${arg}" == "count" ]; then
          echo "$monitors"
        else
          echo monitorData["${arg}"]["${index}"]
        fi
      '';
    };
  parseMonitors = arg: index:
    builtins.readFile (lib.getExe parseMonitorsScript) + " ${arg} ${index}";

  monitorCount = builtins.fromJSON (parseMonitors "count" "");

  monitorIndices = builtins.genList (x: x) monitorCount;

  monitorAttributes = lib.forEach monitorIndices (monitorIndex: {
    name = parseMonitors "name" monitorIndex;
    resolution = parseMonitors "resolution" monitorIndex;
    position = parseMonitors "position" monitorIndex;
    refreshRate = parseMonitors "refreshRate" monitorIndex;
    scale = parseMonitors "scale" monitorIndex;
  });
in
  lib.attrsets.mergeAttrsList monitorAttributes
