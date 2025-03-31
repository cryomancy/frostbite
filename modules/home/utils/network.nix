_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.utils.network;
in {
  options = {
    frostbite.utils.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      angryipscanner # fast and friendly network scanner
      ethtool # Ethernet device settings and diagnostics
      tcpdump # CLI packet analyzer
      nmap # Ttility for network discovery
      nmapsi4 # Qt frontend for nmap
      netcat
      traceroute
      wireshark
      termshark
      iperf # Measure IP bandwidth
      ipcalc
      python312Packages.scapy # Interactive packet manipulation and shell
      tcpreplay
      udpreplay
      mtr # ping + traceroute
      dig
      whois
      arp-scan
      asn # OSINT CLI tool for investigating network data
    ];
  };
}
