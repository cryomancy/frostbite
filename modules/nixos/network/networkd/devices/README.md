## NETWORKD NETWORK ENUMERATION SCHEME

         10-19: Base Network Interfaces (e.g. lo0, wlo0, eth0)
           * 10: wlo1 - Base Wifi Device
           * 20: eth0 - Base Ethernet Device
         20-29: Wireless VLANs
         30-39: Wired VLANs
         40-49:
         50: wireless_bridge
         60: wired_bridge
         70-89: Macvlan Interfaces
         90: Bonded Interfaces

## NETWORKD NETDEV ENUMERATION SCHEME

        10-19:
