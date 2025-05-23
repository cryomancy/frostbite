_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.kmonad;
in {
  options = {
    frostbite.services.kmonad = {
      enable = lib.mkEnableOption "kmonad";
    };
  };

  config = lib.mkIf cfg.enable {
    services.kmonad = {
      enable = false;
      keyboards = {
        all = {
          device = /dev/input/by-id;
          config = ''

            (defcfg
              input  (device-file "/dev/input/by-id/usb-HOLTEK_USB-HID_Keyboard-event-kbd")
              ;; input  (device-file "/dev/input/by-id/usb-Matias_Ergo_Pro_Keyboard-event-kbd")
              output (uinput-sink "KMonad output")
              fallthrough true
            )

            (defsrc
              esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12            prnt    slck    pause
              grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc      ins     home    pgup
              tab     q    w    e    r    t    y    u    i    o    p    [    ]    \         del     end     pgdn
              caps    a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft      z    x    c    v    b    n    m    ,    .    /    rsft                      up
              lctl    lmet lalt           spc            ralt rmet cmp  rctl                left    down    right
            )

            (defalias
              num  (tap-macro nlck (layer-switch numpad)) ;; Bind 'num' to numpad Layer
              def  (tap-macro nlck (layer-switch qwerty)) ;; Bind 'def' to qwerty Layer
              nm2 (layer-toggle numbers) ;; Bind 'nm2' to numbers under left hand layer for fast input
            )

            (deflayer qwerty
              esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12            prnt    @num    pause
              grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc      ins     home    pgup
              tab     q    w    e    r    t    y    u    i    o    p    [    ]    \         del     end     pgdn
              caps    a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft      z    x    c    v    b    n    m    ,    .    /    rsft                      up
              lctl    lmet lalt           spc            ralt rmet @nm2 rctl                left    down    right
            )

            (deflayer numpad
              _       _    _    _    _    _    _    _    _    _    _    _    _              _    @def _
              _       _    _    _    _    XX   kp/  kp7  kp8  kp9  kp-  _    _    _         _    _    _
              _       _    _    _    _    XX   kp*  kp4  kp5  kp6  kp+  XX   XX   _         _    _    _
              _       _    _    _    _    XX  XX    kp1  kp2  kp3  XX   _    _
              _         _    _    _    _    _    XX   kp0  _    _    _    _                      _
              _       _    _                 _              _    _    @nm2 _                _    _    _
            )

            (deflayer numbers
              _       _    _    _    _    _    _    _    _    _    _    _    _              _    _    _
              _       7    8    9    _    _    _    _    _    _    _    _    _    _         _    _    _
              _       4    5    6    _    _    _    _    _    _    _    _    _    _         _    _    _
              _       1    2    3    _    _    _    _    _    _    _    _    _
              _         0    _    _    _    _    _    _    _    _    _    _                      _
              _       _    _                 _              _    _    _    _                _    _    _
            )
          '';
        };
      };
    };
  };
}
