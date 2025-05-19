{lib, ...}: let
  discoveredNetworkDevices = builtins.attrNames (builtins.readDir "/sys/class/net");

  # NOTE: These functions also supply values needed for assertions
  #       as the current configuration only allows for a maximum
  #       of one type of each device.
  #       (If any return greater than one than throw an error.)
  hasEthernetDevice = lib.lists.count (x: builtins.match x) discoveredNetworkDevices;
  hasWifiDevice = lib.lists.count (x: builtins.match x) discoveredNetworkDevices;
  hasLoopbackDevice = lib.lists.count (x: builtins.match x) discoveredNetworkDevices;
in [
  {
    assertion = hasEthernetDevice < 2;
    message = "This configuration is currently built for a maximum of one ethernet device per system.";
  }
  {
    asertion = hasWifiDevice < 2;
    message = "This configuration is currently built for a maximum of one Wifi device per system.";
  }
  {
    asertion = hasLoopbackDevice < 2;
    message = "This configuration is currently built for a maximum of one loopback device per system.";
  }
]
