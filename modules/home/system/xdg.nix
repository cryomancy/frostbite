_:
{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.frostbite.system.xdg;
  dir = "${config.home.homeDirectory}";
in
{
  options = {
    frostbite.system.xdg = {
      enable = lib.mkOption {
        default = false;
        example = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [ ".config/boxxy" ];
      };
    };

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = null;
        download = "${dir}/inbox";
        documents = "${dir}/documents";
        music = null;
        pictures = "${dir}/pictures";
        publicShare = null;
        templates = null;
        videos = null;
        extraConfig = {
          XDG_PROJECTS_DIR = "${dir}/projects";
          XDG_SYSTEM_DIR = "${dir}/system";
          XDG_MISC_DIR = "${dir}/misc";
          XDG_SCREENSHOTS_DIR = "${dir}/pictures/screenshots";
        };
      };
    };

    programs = {
      boxxy = {
        enable = true;
        #rules = [
        #
        #];
      };
    };

    xdg.configFile."boxxy/boxxy.yaml".text = ''
      rules:
      - name: vim
        target: ~/.vim
        rewrite: ~/.local/share/vim
        mode: file
        context: []
        only: []
        env: {}
      - name: vim
        target: ~/.vimrc
        rewrite: ~/.config/vim/vimrc
        mode: file
        context: []
        only: []
        env: {}
      - name: vim
        target: ~/.viminfo
        rewrite: ~/.local/share/vim/viminfo
        mode: file
        context: []
        only: []
        env: {}
      - name: vim
        target: ~/.vim
        rewrite: ~/.local/share/vim
        mode: file
        context: []
        only: []
        env: {}
      - name: vim
        target: ~/.vimrc
        rewrite: ~/.config/vim/vimrc
        mode: file
        context: []
        only: []
        env: {}
      - name: vim
        target: ~/.viminfo
        rewrite: ~/.local/share/vim/viminfo
        mode: file
        context: []
        only: []
        env: {}
      - name: GnuPG
        target: ~/.gnupg
        rewrite: ~/.local/share/gnupg
        mode: file
        context: []
        only: []
        env: {}
      - name: GTK 2
        target: ~/.gtkrc-2.0
        rewrite: ~/.config/gtk-2.0/gtkrc
        mode: file
        context: []
        only: []
        env: {}
      - name: w3m
        target: ~/.w3m
        rewrite: ~/.config/w3m
        mode: file
        context: []
        only: []
        env: {}
    '';
  };
}
