scoped: {
  lib,
  pkgs,
}: let
  parseMonitors = arg: index:
    pkgs.writeShellScript "parseMonitors.sh"
    ''
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
in
  lib.attrsets.mergeAttrsList (
    lib.forEach
    (builtins.genList (x: x)
      (builtins.exec [(parseMonitors "count" "")]))
    (
      monitorIndex: {
        name = parseMonitors "name" monitorIndex;
        resolution = parseMonitors "resolution" monitorIndex;
        position = parseMonitors "position" monitorIndex;
        refreshRate = parseMonitors "refreshRate" monitorIndex;
        scale = parseMonitors "scale" monitorIndex;
      }
    )
  )
