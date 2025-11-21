_:
{
  pkgs,
  config,
  lib,
  nixosConfig,
  user,
  ...
}:
let
  cfg = config.frostbite.shells.fish;
  wslIntegration = nixosConfig.frostbite.support.guest.wsl.enable;
in
{
  options = {
    frostbite.shells.fish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [
          ".config/fish"
        ];
      };
    };
    programs = {
      fish = {
        enable = true;
        interactiveShellInit = lib.strings.concatStringsSep " " [
          ''
            ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

            set -U fish_greeting
          ''

          ((lib.strings.optionalString wslIntegration) ''fish_add_path --append /mnt/c/Users/${config.home.username}/AppData/Local/Microsoft/WinGet/Packages/equalsraf.win32yank_Microsoft.Winget.Source_8wekyb3d8bbwe/'')
        ];

        functions = {
          refresh = "source $HOME/.config/fish/config.fish";
          take = ''mkdir -p -- "$1" && cd -- "$1"'';
          ttake = "cd $(mktemp -d)";
          show_path = "echo $PATH | tr ' ' '\n'";
          posix-source = ''
            for i in (cat $argv)
              set arr (echo $i |tr = \n)
              set -gx $arr[1] $arr[2]
            end
          '';
        };
        shellAbbrs = {
          gc = "nix-collect-garbage --delete-old";
        }
        # navigation shortcuts
        // {
          ".." = "cd ..";
          "..." = "cd ../../";
          "...." = "cd ../../../";
          "....." = "cd ../../../../";
        }
        # git shortcuts
        // {
          gapa = "git add --patch";
          grpa = "git reset --patch";
          gst = "git status";
          gdh = "git diff HEAD";
          gp = "git push";
          gph = "git push -u origin HEAD";
          gco = "git checkout";
          gcob = "git checkout -b";
          gcm = "git checkout master";
          gcd = "git checkout develop";
          gsp = "git stash push -m";
          gsa = "git stash apply stash^{/";
          gsl = "git stash list";
        };
        shellAliases = lib.mkIf wslIntegration {
          jvim = "nvim";
          lvim = "nvim";
          pbcopy = "/mnt/c/Windows/System32/clip.exe";
          pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
          explorer = "/mnt/c/Windows/explorer.exe";
        };
        plugins = [
          {
            inherit (pkgs.fishPlugins.autopair) src;
            name = "autopair";
          }
          {
            inherit (pkgs.fishPlugins.done) src;
            name = "done";
          }
          {
            inherit (pkgs.fishPlugins.sponge) src;
            name = "sponge";
          }
        ];
      };
    };

    home.sessionVariables.SHELL = /etc/profiles/per-user/${config.home.username}/bin/fish;
  };
}
