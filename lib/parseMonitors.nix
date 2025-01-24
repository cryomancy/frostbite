scoped: {
  lib,
  pkgs,
}: let
  parseMonitors = lib.getExe (pkgs.writeShellApplication {
    name = "parseMonitors.sh";
    runtimeInputs = with pkgs; [hyprland coreutils];
    text = ''
      monitors=$(hyprctl monitors all | grep Monitor | awk 'END {print NR}')
      monitorNames=$(hyprctl monitors all | grep Monitor | awk '{print $2}')
      resolutions=$(hyprctl monitors all | grep ' at ' | awk '{print $1}')
      positions=$(hyprctl monitors all | grep ' at ' | awk '{print $3}')
      scales=$(hyprctl monitors all | grep 'scale' | awk '{print $2}')

      # Declare an array to hold monitor data
      monitorData=()

      for i in $(seq 0 $(($monitors - 1))); do
        # Assign the data for each monitor to a dictionary
        monitorData[$i]=$(echo "$monitorNames $resolutions $positions $scales" | cut -d' ' -f$((i + 1)))
      done

      # Output the relevant data based on the parameter
      if [ $1 == "count" ]; then
        echo $monitors
      else
        echo monitorData[$1][$2]
      fi
    '';
  });

  parsedMonitors = lib.attrsets.mergeAttrsList (
    lib.forEach (builtins.genList (x: x + 1) (pkgs.callPackage parseMonitors "count"))
    (
      monitorIndex: {
        name = parseMonitors "name" monitorIndex;
        resolution = parseMonitors "resolution" monitorIndex;
        position = parseMonitors "position" monitorIndex;
        refreshRate = parseMonitors "refreshRate" monitorIndex;
        scale = parseMonitors "scale" monitorIndex;
      }
    )
  );
in
  parsedMonitors
