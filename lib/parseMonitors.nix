{ lib, pkgs, ... }:

let
  # Define the shell script that interacts with `hyprctl` and retrieves monitor data
  parseMonitors = pkgs.writeShellApplication {
    name = "parseMonitors.sh";
    excludeShellChecks = ["SC2034"];
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
  } |> lib.getExe |> builtins.readFile;

  # Format the output based on the monitor index
  formattedOutput = monitorIndex: {
    "${monitorIndex}" = {
      name = parseMonitors "name" monitorIndex;
      resolution = parseMonitors "resolution" monitorIndex;
      position = parseMonitors "position" monitorIndex;
      refreshRate = parseMonitors "refreshRate" monitorIndex;
      scale = parseMonitors "scale" monitorIndex;
    };
  };

  # Use `builtins.exec` to count monitors (output from the shell script)
  monitorCountOutput = builtins.exec ["${parseMonitors}" "--" "count"];

  # Parse the count to generate the list of monitors
  monitors = lib.genList (i: formattedOutput i) (builtins.toString monitorCountOutput);

in 
  monitors
