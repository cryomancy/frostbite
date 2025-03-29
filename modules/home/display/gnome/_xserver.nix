_: {
  xserver.desktopManager.gnome.sessionPath = [
    pkgs.gnome-shell
    pkgs.gnome-shell-extensions
  ];

  xserver.updateDbusEnvironment = true;
}
