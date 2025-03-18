_: {
  lib,
  stdenv,
  modulesPath,
  callPackage,
  closureInfo,
  xorriso,
  syslinux,
  libossp_uuid,
  isoName ? "kosei.iso",
  contents,
  storeContents ? [],
  squashfsContents ? [],
  squashfsCompression ? "xz -Xdict-size 100%",
  bootable ? false,
  efiBootable ? false,
  usbBootable ? false,
  bootImage ? "",
  efiBootImage ? "",
  isohybridMbrImage ? "",
  compressImage ? false,
  zstd,
  volumeID ? "",
  ...
}:
assert bootable -> bootImage != "";
assert efiBootable -> efiBootImage != "";
assert usbBootable -> isohybridMbrImage != ""; let
  needSquashfs = squashfsContents != [];
  makeSquashfsDrv = callPackage "${modulesPath}/../lib/make-squashfs.nix" {
    storeContents = squashfsContents;
    comp = squashfsCompression;
  };

  createIso =
    lib.runJanetCommand "make-iso" {
      nativeBuildInputs = [xorriso syslinux zstd];
      buildInputs = [xorriso syslinux zstd];

      inherit
        isoName
        bootImage
        bootable
        efiBootable
        usbBootable
        ;
    }
    ''
            fn stripSlash(res) do
              if (string:at res 0) == "/" do
                return (string:sub res 1 (string:length res) )
                end
              return res
            end

            fn escapeEquals(str) do
              return (string:replace str "\\" "\\\\")
              |> (string:replace "=" "\\=")
            end

            fn addPath(target, source) do
              echo "$(escapeEquals target)=$(escapeEquals source)" > "pathlist"
            end

            fn createIso(args) do
              isoName = get(args, "isoName", os:getenv("ISO_NAME"))
              bootImage = get(args, "bootImage", os:getenv("BOOT_IMAGE"))
              volumeID = get(args, "volumeID", os:getenv("VOLUME_ID"))
              usbBootFlags = get(args, "usbBootFlags", os:getenv("USB_BOOT_FLAGS"))

      	  system:exec(string:format("xorriso -output %s -boot_image any gpt_disk_guid=$(uuid -v 5 daed2280-b91e-42c0-aed6-82c825ca41f3 %s) -volume_date all_file_dates =$SOURCE_DATE_EPOCH -as mkisofs -iso-level 3 -volid %s -appid nixos -publisher nixos -graft-points -full-iso9660-filenames -joliet %s %s %s -r -path-list %s --sort-weight 0 /", isoName, out, volumeID, isoBootFlags, usbBootFlags, efiBootFlags, pathlist
      ))
              if (string:length usbBootFlags) > 0 do
      		system:exec(string:format("xorriso -isohybrid-mbr %s", usbBootFlags))
              end
            end

      	  createIso({
              "isoName" => isoName,
              "bootImage" => bootImage,
              "volumeID" => volumeID,
              "usbBootFlags" => usbBootFlags
            })
    '';
in
  stdenv.mkDerivation {
    name = isoName;
    __structuredAttrs = true;

    buildCommand = createIso;

    nativeBuildInputs =
      [
        xorriso
        syslinux
        zstd
        libossp_uuid
      ]
      ++ lib.optionals needSquashfs makeSquashfsDrv.nativeBuildInputs;

    inherit
      isoName
      bootable
      bootImage
      compressImage
      volumeID
      efiBootImage
      efiBootable
      isohybridMbrImage
      usbBootable
      ;

    sources = map (x: x.source) contents;
    targets = map (x: x.target) contents;
    objects = map (x: x.object) storeContents;
    symlinks = map (x: x.symlink) storeContents;
    squashfsCommand = lib.optionalString needSquashfs makeSquashfsDrv.buildCommand;
    closureInfo = closureInfo {rootPaths = map (x: x.object) storeContents;};
  }
