scoped: {lib, ...}: {
  geoclue2 = {
    enable = lib.mkDefault true;
    enableDemoAgent = false;
    appConfig = {
      gnome-datetime-panel = {
        isAllowed = true;
        isSystem = true;
      };
      gnome-color-panel = {
        isAllowed = true;
        isSystem = true;
      };
      "org.  Shell" = {
        isAllowed = true;
        isSystem = true;
      };
    };
  };
}
