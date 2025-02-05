{
  home-manager.users."user".fuyuNoKosei = {
    browser.firefox.enable = true;
    fileManager.enable = false;
    git = {
      enable = true;
      userName = "Foo Bar";
      userEmail = "foobar@proton.me";
    };
    homePackages.enable = true;
    hyprland.enable = false;
    passwordManagement.enable = true;
    rofi.enable = false;
    waybar.enable = false;
  };
}
