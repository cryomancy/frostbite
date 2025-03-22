{
  config,
  lib,
  pkgs,
  ...
}: {name, ...}: {
  options = {
    name = lib.mkOption {
      type = lib.types.passwdEntry lib.types.str;
      description = ''
        The name of the user account. If undefined, the name of the
        attribute set will be used.
      '';
    };

    isSystemUser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Indicates if the user is a system user or not. This option
        only has an effect if {option}`uid` is
        {option}`null`, in which case it determines whether
        the user's UID is allocated in the range for system users
        (below 1000) or in the range for normal users (starting at
        1000).
        Exactly one of `isNormalUser` and
        `isSystemUser` must be true.
      '';
    };

    isNormalUser = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Indicates whether this is an account for a “real” user.
        This automatically sets {option}`group` to `users`,
        {option}`createHome` to `true`,
        {option}`home` to {file}`/home/«username»`,
        {option}`useDefaultShell` to `true`,
        and {option}`isSystemUser` to `false`.
        Exactly one of `isNormalUser` and `isSystemUser` must be true.
      '';
    };

    isAdministrator = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Indicates whether this account is a system administrator.
        This will add the user to the necessary groups to perform
        administrative tasks without having to become root.
      '';
    };

    home = lib.mkOption {
      type = lib.types.passwdEntry lib.types.path;
      default = "/home/${name}";
      description = "The user's home directory.";
    };

    shell = lib.mkOption {
      type = lib.types.nullOr (lib.types.either lib.types.shellPackage (lib.types.passwdEntry lib.types.path));
      default = pkgs.fish;
      defaultText = lib.literalExpression "pkgs.shadow";
      example = lib.literalExpression "pkgs.bashInteractive";
      description = ''
        The path to the user's shell. Can use shell derivations,
        like `pkgs.bashInteractive`. Don’t
        forget to enable your shell in
        `programs` if necessary,
        like `programs.zsh.enable = true;`.
      '';
    };

    createHome = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to create the home directory and ensure ownership as well as
        permissions to match the user.
      '';
    };

    hashedPasswordFile = lib.mkOption {
      type = with lib.types; nullOr str;
      default = lib.mkDefault (
        if config.kosei.secrets.enable
        then config.sops.secrets."${name}/hashedPasswordFile".path
        else null
      );

      defaultText = lib.literalExpression "null";
      description = ''
        The full path to a file that contains the hash of the user's
        password. The password file is read on each system activation. The
        file should contain exactly one line, which should be the password in
        an encrypted form that is suitable for the `chpasswd -e` command.
      '';
    };

    initialPassword = lib.mkOption {
      type = with lib.types; nullOr str;
      default = lib.mkDefault (
        if !config.kosei.secrets.enable
        then config.kosei.initialPassword
        else null
      );
      description = ''
        Specifies the initial password for the user, i.e. the
        password assigned if the user does not already exist. If
        {option}`users.mutableUsers` is true, the password
        can be changed subsequently using the
        {command}`passwd` command. Otherwise, it's
        equivalent to setting the {option}`password`
        option. The same caveat applies: the password specified here
        is world-readable in the Nix store, so it should only be
        used for guest accounts or passwords that will be changed
        promptly.
      '';
    };
  };
}
