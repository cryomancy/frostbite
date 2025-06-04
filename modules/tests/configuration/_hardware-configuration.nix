{
  config,
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  system.includeBuildDependencies = lib.mkForce false;

  networking = {
    hostName = "yoru";
  };

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["samsung_galaxybook"];
      luks.devices."crypted".device = "/dev/disk/by-uuid/96ce0bc2-93c0-4b1a-b807-4b5a958e5c01";
    };
    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_14.override {
      argsOverride = rec {
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
          sha256 = "sha256-dYaWJUeAO+fsxAVu/JJ/slIUVIcivSgXEXLzWZq7l2Q=";
        };
        version = "6.15";
        modDirVersion = "6.15.0";
      };
    });
    kernelParams = [
      # "acpi_backlight=vendor"
      # "acpi_osi=Linux"
      # "snd-hda-intel"
      # "model=laptop-dmic"
      # "i915.enable_dpcd_backlight=3"
      # "i915.enable_dp_mst=0"
      # "i915.enable_psr2_sel_fetch=1"
    ];
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f479ea2a-00ea-4cc2-83ee-c9d458b67193";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/f479ea2a-00ea-4cc2-83ee-c9d458b67193";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/f479ea2a-00ea-4cc2-83ee-c9d458b67193";
      fsType = "btrfs";
      options = ["subvol=home"];
    };

    "/.swapvol" = {
      device = "/dev/disk/by-uuid/f479ea2a-00ea-4cc2-83ee-c9d458b67193";
      fsType = "btrfs";
      options = ["subvol=swap"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7F60-3E7E";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.udev.extraHwdb = ''
    # Notebook and Galaxy Book series (SKU Number: SCAI-*)
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svn[sS][aA][mM][sS][uU][nN][gG]*:sku*SCAI*:*
     KEYBOARD_KEY_81=!esc
     KEYBOARD_KEY_ce=!prog1                                 # Fn+F1 launch settings
     KEYBOARD_KEY_76=f21                                    # Fn+F5 Touchpad toggle
     KEYBOARD_KEY_ae=!volumedown                            # Fn+F7 volume down
     KEYBOARD_KEY_b0=!volumeup                              # Fn+F8 volume up
     KEYBOARD_KEY_ac=unknown                                # Fn+F9 multi-level keyboard backlight toggle - handled by samsung-galaxybook
     KEYBOARD_KEY_9f=unknown                                # Fn+F10 Camera and microphone toggle - handled by samsung-galaxybook
     KEYBOARD_KEY_a8=!unknown                               # Fn+F12 Fn lock On - handled by hardware
     KEYBOARD_KEY_a9=!unknown                               # Fn+F12 Fn lock Off - handled by hardware
  '';
}
