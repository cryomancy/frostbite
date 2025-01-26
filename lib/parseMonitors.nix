scoped: {
  lib,
  pkgs,
}: let
  parseMonitors = arg: index:
    lib.getExe (pkgs.writeShellApplication {
      name = "parseMonitors.sh";
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
    });

  # Execute the script to get the monitor count and convert it to an integer
  monitorCount = builtins.fromJSON (builtins.readFile (parseMonitors "count" ""));

  # Generate a list of monitor indices
  monitorIndices = builtins.genList (x: x) monitorCount;

  # Create a list of monitor attributes
  monitorAttributes = lib.forEach monitorIndices (monitorIndex: {
    name = builtins.readFile (parseMonitors "name" monitorIndex);
    resolution = builtins.readFile (parseMonitors "resolution" monitorIndex);
    position = builtins.readFile (parseMonitors "position" monitorIndex);
    refreshRate = builtins.readFile (parseMonitors "refreshRate" monitorIndex);
    scale = builtins.readFile (parseMonitors "scale" monitorIndex);
  });
in
  lib.attrsets.mergeAttrsList monitorAttributes
