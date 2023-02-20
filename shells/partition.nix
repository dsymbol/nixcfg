{ pkgs ? import <nixpkgs> { } }:

let
  disk = "/dev/sda";
  p1 = if pkgs.lib.hasPrefix "/dev/nvme" disk then "p1" else "1";
  p2 = if pkgs.lib.hasPrefix "/dev/nvme" disk then "p2" else "2";
  uefi = builtins.pathExists "/sys/firmware/efi";

  partition =
    if uefi then
      pkgs.writeScriptBin "partition" ''
        echo "UEFI detected"
        # Partition the disk
        parted -s ${disk} -- mklabel gpt
        parted -s ${disk} -- mkpart ESP fat32 0% 500MiB
        parted -s ${disk} -- mkpart primary 500MiB 100%
        parted -s ${disk} -- set 1 esp on
        # Create the filesystems for the partitions
        mkfs.vfat -F 32 ${disk}${p1} -n BOOT
        mkfs.btrfs -q ${disk}${p2} -L ROOT -f
        # Mount the partitions
        udevadm trigger --subsystem-match=block
        udevadm settle
        # Mount the partitions
        mount -t btrfs -o compress=zstd,noatime,ssd,space_cache=v2 /dev/disk/by-label/ROOT /mnt
        mkdir -p /mnt/boot
        mount /dev/disk/by-label/BOOT /mnt/boot
        # Verify partitioning
        lsblk ${disk} -o name,mountpoint,label,size,uuid
      ''
    else
      pkgs.writeScriptBin "partition" ''
        echo "Legacy BIOS detected"
        # Partition the disk
        parted -s ${disk} -- mklabel msdos
        parted -s ${disk} -- mkpart primary 0% 100%
        parted -s ${disk} -- set 1 boot on
        # Create the filesystems for the partitions
        mkfs.btrfs -q ${disk}${p1} -L ROOT -f
        udevadm trigger --subsystem-match=block
        udevadm settle
        # Mount the partition
        mount -t btrfs -o compress=zstd,noatime,ssd,space_cache=v2 /dev/disk/by-label/ROOT /mnt
        # Verify partitioning
        lsblk ${disk} -o name,mountpoint,label,size,uuid
      '';

  wipe = pkgs.writeScriptBin "wipe" ''
    umount /mnt/boot
    umount /mnt
    dd if=/dev/zero of=${disk} bs=512 count=1 conv=notrunc
  '';
in
pkgs.mkShell {
  buildInputs = [ pkgs.parted partition wipe ];
  shellHook = ''
    echo Warning: All data on set disk \(default: /dev/sda\) will be destroyed when running either of the commands.
  '';
}
