_: {
  lib,
  pkgs,
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

  createIso = pkgs.runCommand "make-iso" {
    nativeBuildInputs = [xorriso syslinux zstd];
    buildInputs = [xorriso syslinux zstd];

    inherit
      isoName
      bootImage
      bootable
      efiBootable
      usbBootable
      ;

    installPhase = ''
          stripSlash() {
            res="$1"
            if ["${res:0:1}" = /;];
        then res=${res:1};
      fi
          }

       escapeEquals() {
            echo "$1" | sed -e 's/\\/\\\\/g' -e 's/=/\\=/g'
          }

       addPath() {
            target="$1"
            source="$2"
            echo "$(escapeEquals "$target")=$(escapeEquals "$source")" >> pathlist
          }

       stripSlash "$bootImage"; bootImage="$res"

       if [ -n "$bootable" ]; then
            for ((i = 0; i < ''${#targets[@]}; i++)); do
              stripSlash "''${targets[$i]}"
              if test "$res" = "$bootImage"; then
                echo "copying the boot image ''${sources[$i]}"
                cp "''${sources[$i]}" boot.img
                chmod u+w boot.img
                sources[$i]=boot.img
              fi
            done

            isoBootFlags="-eltorito-boot ''${bootImage}
                      -eltorito-catalog .boot.cat
                      -no-emul-boot -boot-load-size 4 -boot-info-table
                      --sort-weight 1 /isolinux" # Make sure isolinux is near the beginning of the ISO
          fi

         if [ -n "$usbBootable" ]; then
           usbBootFlags="-isohybrid-mbr ''${isohybridMbrImage}"
         fi

         if [ -n "$efiBootable" ]; then
            efiBootFlags="-eltorito-alt-boot
            -e $efiBootImage
            -no-emul-boot
            -isohybrid-gpt-basdat"
          fi

          touch pathlist

       for ((i = 0; i < ''${#targets[@]}; i++)); do
            stripSlash "''${targets[$i]}"
            addPath "$res" "''${sources[$i]}"
          done

          for i in $(< $closureInfo/store-paths); do
            addPath "''${i:1}" "$i"
          done

          if [[ -n "$squashfsCommand" ]]; then
            (out="nix-store.squashfs" eval "$squashfsCommand")
            addPath "nix-store.squashfs" "nix-store.squashfs"
          fi

          if [[ ''${#objects[*]} != 0 ]]; then
            cp $closureInfo/registration nix-path-registration
            addPath "nix-path-registration" "nix-path-registration"
          fi

       for ((n = 0; n < ''${#objects[*]}; n++)); do
            object=''${objects[$n]}
            symlink=''${symlinks[$n]}
            if test "$symlink" != "none"; then
              mkdir -p $(dirname ./$symlink)
              ln -s $object ./$symlink
              addPath "$symlink" "./$symlink"
            fi
          done


          mkdir -p $out/iso
          mkdir -p $out/nix-support

          xorriso -output $out/iso/$isoName
            -boot_image any gpt_disk_guid=$(uuid -v 5 daed2280-b91e-42c0-aed6-82c825ca41f3 $out) \
            -volume_date all_file_dates =$SOURCE_DATE_EPOCH -as mkisofs -iso-level 3 \
            -volid ''${volumeID} -appid nixos -publisher nixos -graft-points \
            -full-iso9660-filenames \
            -joliet ''${isoBootFlags} ''${usbBootFlags} ''${efiBootFlags} \
            -r -path-list pathlist --sort-weight 0 /

          if [ -n "$compressImage" ]; then
            zstd -T$NIX_BUILD_CORES --rm $out/iso/$isoName
      echo "file iso $out/iso/$isoName.zst" >> $out/nix-support/hydra-build-products
       else
            echo "file iso $out/iso/$isoName" >> $out/nix-support/hydra-build-products
          fi

       echo $system > $out/nix-support/system
    '';
  };
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
