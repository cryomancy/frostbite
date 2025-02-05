{
  home-manager.users = {
    "user".fuyuNoKosei = {
      fileManager.enable = true;
      homePackages.enable = true;
      hyprland.enable = true;
      passwordManagement.enable = true;
      syncthing.enable = true;
      rofi.enable = true;
      waybar.enable = true;
    };
    "test".fuyuNoKosei = {
      hyprland.enable = true;
      rofi.enable = true;
      waybar.enable = true;
      homePackages.enable = true;
    };
  };
}
