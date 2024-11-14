{pkgs, ...}: {
  android-integration = {
  };

  build = {
  };

  environment = {
    packages = with pkgs; [
      zsh
    ];
  };

  system.stateVersion = "24.05";
}
