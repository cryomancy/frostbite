scoped: lib: parameter: monitor: let
  # Capture monitor data using `hyprctl`
  parseHyprctlMonitors = lib.writeShellScriptBin "parseHyprctlMonitors" ''
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
    if [ "${parameter}" == "count" ]; then
      echo $monitors
    else
      echo monitorData[${parameter}]
    fi
  '';
in
  lib.mergeAttrsList (
    lib.forEach (builtins.genList (x: x + 1) (parseHyprctlMonitors "count" ""))
    (monitorIndex: {
      name = parseHyprctlMonitors "name" monitorIndex;
      position = parseHyprctlMonitors "position" monitorIndex;
      resolution = parseHyprctlMonitors "resolution" monitorIndex;
      refreshRate = parseHyprctlMonitors "refreshRate" monitorIndex;
      scale = parseHyprctlMonitors "scale" monitorIndex;
    })
  )
