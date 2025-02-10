scoped: {
  config,
  inputs,
  lib,
  username,
  ...
}: let
  cfg = config.kosei.impermanence;
in {
  imports = [inputs.impermanence.homeManagerModules.impermanence];

  options = {
    kosei.impermanence.enable = lib.mkEnableOption "impermanence";
  };

  config = lib.mkIf cfg.enable {
    home.persistence = {
      "/persist/home/${username}" = {
        allowOther = true;

        directories = [
          "go"
          ".docker"
          ".emacs.d"
          ".flutter-devtools"
          ".kube"
          ".m2"
          ".mozilla"
          ".librewolf"
          ".thunderbird"
          ".obsidian"
          ".openvpn"
          ".password-store"
          ".themes"
          ".terraform.d"
          ".yandex"
          ".ollama"
          ".config/google-chrome"
          ".config/sops"
          ".config/vesktop"
          ".config/sops-nix"
          ".config/obsidian"
          ".config/Code"
          ".config/dconf"
          ".config/htop"
          ".config/nvim"
          ".config/syncthing"
          ".config/obs-studio"
          ".config/pulse"
          ".local/share/chat.fluffy.fluffychat"
          ".local/share/zoxide"
          ".local/share/fish"
          ".local/share/nix"
          ".local/share/containers"
          ".local/share/Trash"
          ".local/share/TelegramDesktop"
          ".local/share/keyrings"
          ".local/share/nvim"
          ".local/state"
          ".vscode"
          ".pki"
          ".ssh"
          ".gnupg"
        ];

        files = [
          ".bash_history"
          ".bash_logout"
          ".flutter"
          ".face"
          ".face.icon"
          ".zsh_history"
          ".cache/cliphist/db"
        ];
      };
    };
  };
}
