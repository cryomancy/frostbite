scoped: {
  lib,
  pkgs,
}: let
  # Create a derivation for the parseMonitors script
  parseMonitorsScript = pkgs.writeShellScriptBin "parseMonitors" ''
    set -o errexit
    set -o nounset
    set -o pipefail

    export PATH="${lib.makeBinPath (with pkgs; [hyprland coreutils])}:$PATH"

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

  # Function to execute the script and capture its output
  parseMonitors = arg: index:
    builtins.readFile (lib.getExe parseMonitorsScript) + " ${arg} ${index}";

  # Get the monitor count as an integer
  monitorCount = builtins.fromJSON (parseMonitors "count" "");

  # Generate a list of monitor indices
  monitorIndices = builtins.genList (x: x) monitorCount;

  # Create a list of monitor attributes
  monitorAttributes = lib.forEach monitorIndices (monitorIndex: {
    name = parseMonitors "name" monitorIndex;
    resolution = parseMonitors "resolution" monitorIndex;
    position = parseMonitors "position" monitorIndex;
    refreshRate = parseMonitors "refreshRate" monitorIndex;
    scale = parseMonitors "scale" monitorIndex;
  });
in
  lib.attrsets.mergeAttrsList monitorAttributes
