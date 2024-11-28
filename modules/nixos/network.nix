{
  config,
  hostName,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.network;
in {
  options = {
    fuyuNoKosei.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      inherit hostName;
      firewall = {
        allowPing = true;
      };
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;
      useNetworkd = false;
    };

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    programs.openvpn3 = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      gnome-control-center
    ];

    services.openvpn.servers = {
      #local = {
      #  config = ''
      #    dev tun
      #    ifconfig 10.8.0.1 10.8.0.2
      #    secret /root/static.key # put this in secrets
      #    proto udp
      #    port 1194
      #    cipher AES-128-CBC
      #    auth SHA1
      #    keepalive 10 30
      #    comp-lzo yes
      #    push "redirect-gateway def1"
      #    push "dhcp-option DNS 8.8.8.8"
      #    push "dhcp-option DNS 8.8.4.4"
      #  '';
      #  up = "ip route add ...";
      #  down = "ip route del ...";
      #};

      #    home = {
      #      config = ''
      #        client
      #        remote ${secrets}
      #        float
      #        nobind
      #        proto udp
      #        dev tun
      #        sndbuf 0
      #        rcvbuf 0
      #        keepalive 10 30
      #        auth-user-pass
      #        auth SHA1
      #        cipher AES-128-CBC
      #        data-ciphers AES-128-CBC
      #        remote-cert-tls server
      #        comp-lzo yes
      #        ca /etc/openvpn/ca.crt
      #        cert /etc/openvpn/client.crt ${secrets}
      #        key /etc/openvpn/client.key ${secrets}
      #        verb 3
      #      '';
      #      up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
      #      down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
      #    };
    };
  };
}
