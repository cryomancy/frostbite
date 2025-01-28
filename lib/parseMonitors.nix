scoped: { lib, pkgs, ... }:

let
  # Define the shell script that interacts with `hyprctl` and retrieves monitor data
  parseMonitors = pkgs.writeTextFile {
    name = "parseMonitors.sh";
	executable = true;
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

      if [ "$1" == "count" ]; then
        echo "$monitors"
      else
        echo monitorData["$1"]["$2"]
      fi
    '';
  } |> builtins.readFile;

  callAttr = attr: monitorIndex:  builtins.exec ["bash" "-c" "${parseMonitors}" "--" "${attr}" "${monitorIndex}"];

  monitorCountOutput = builtins.exec ["bash" "-c" "${parseMonitors}" "--" "count"];

  formattedOutput = monitorIndex: {
    "${monitorIndex}" = {
      name = callAttr "name" monitorIndex;
      resolution = callAttr "resolution" monitorIndex;
      position = callAttr "position" monitorIndex;
      refreshRate = callAttr "refreshRate" monitorIndex;
      scale = callAttr "scale" monitorIndex;
    };
  };

  monitors = lib.genList (i: formattedOutput i) (builtins.toString monitorCountOutput) |> lib.attrsets.mergeAttrsList;

in 
  monitors
