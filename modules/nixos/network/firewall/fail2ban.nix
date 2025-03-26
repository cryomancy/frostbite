_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.networking.fail2ban;
in {
  options = {
	kosei.networking = {
	  fail2ban = {
		type = lib.types.submodule;
		option = lib.mkOption {
		  enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
		  };
		};
	  };
	};
  };

  # Good resources:
  # https://dataswamp.org/~solene/2022-10-02-nixos-fail2ban.html

  config = lib.mkIf cfg.enable {
    services = {
      fail2ban = {
	    enable = true;
		extraPackages = [pkgs.ipset];
        banaction = "iptables-ipset-proto6-allports";
	    ignoreIP = [
          "192.168.0.0/16"
        ];

		jails = {
          "nginx-spam" = ''
            enabled  = true
            filter   = nginx-bruteforce
            logpath = /var/log/nginx/access.log
            backend = auto
            maxretry = 6
            findtime = 600
          '';
		};
      };
    };

	environment.etc = {
	  "fail2ban/filter.d/nginx-bruteforce.conf".text = ''
      [Definition]
      failregex = ^<HOST>.*GET.*(matrix/server|\.php|admin|wp\-).* HTTP/\d.\d\" 404.*$
      '';
	};
  };
}
