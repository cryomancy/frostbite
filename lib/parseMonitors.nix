scoped: {
  lib,
  pkgs,
}: let
  parseMonitors = pkgs.writeShellApplication {
    name = "parseMonitors.sh";
	checkPhase = ["SC2034"];
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

in
  lib.attrsets.mergeAttrsList (
    lib.forEach
    (builtins.genList (x: x)
      (builtins.exec [(parseMonitors "count" "")]))
    (
      monitorIndex: {
        "${monitorIndex}" = {
          name = parseMonitors "name" monitorIndex;
          resolution = parseMonitors "resolution" monitorIndex;
          position = parseMonitors "position" monitorIndex;
          refreshRate = parseMonitors "refreshRate" monitorIndex;
          scale = parseMonitors "scale" monitorIndex;
        };
      }
    )
  )
