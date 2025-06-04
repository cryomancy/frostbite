{
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    backupFileExtension = lib.mkForce "temp";
    users = {
      "tahlon" = {
        home.pointerCursor.size = 2;
        home.packages = with pkgs; [multivnc];
        stylix.targets.hyprpaper.enable = lib.mkForce false;
        frostbite = {
          browser.firefox.enable = true;
          programs = {
            git = {
              enable = true;
              userName = "Tahlon Brahic";
              userEmail = "tahlonbrahic@proton.me";
            };
            gpg.enable = false;
          };
          display.hyprland = {
            enable = true;
          };
          security.keepassxc.enable = true;
        };
      };
    };
  };
}
