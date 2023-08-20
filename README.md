# nixcfg

This repository contains my personal NixOS configuration. By leveraging the declarative and reproducible nature of NixOS, I can maintain a deterministic system configuration that can be easily replicated. My configuration includes packages, system services, and user-level configuration files tailored to my needs and preferences.

## Installation

Download [NixOS](https://nixos.org/download.html) ISO and boot into it, then switch to the root user with `sudo su` command.

### Partitioning

Use the `parted -l` command to identify the disk you want to use for the installation.

Here's an example partition scheme using /dev/sda as the device. 

####  UEFI (GPT)

```bash
# Partition the disk
parted -s /dev/sda -- mklabel gpt
parted -s /dev/sda -- mkpart ESP fat32 0% 500MiB
parted -s /dev/sda -- mkpart primary 500MiB 100%
parted -s /dev/sda -- set 1 esp on
# Create the filesystems for the partitions
mkfs.vfat -F 32 /dev/sda1 -n BOOT
mkfs.btrfs /dev/sda2 -L ROOT -f
# Mount the partitions
mount -t btrfs -o compress=zstd,noatime,ssd,space_cache=v2 /dev/disk/by-label/ROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
```

#### Legacy BIOS (MBR)

```bash
# Partition the disk
parted -s /dev/sda -- mklabel msdos
parted -s /dev/sda -- mkpart primary 0% 100%
parted -s /dev/sda -- set 1 boot on
# Create the filesystems for the partitions
mkfs.btrfs /dev/sda1 -L ROOT -f
# Mount the partitions
mount -t btrfs -o compress=zstd,noatime,ssd,space_cache=v2 /dev/disk/by-label/ROOT /mnt
```

### Installing

To install the system, define the `username` and `host` variables in the `flake.nix` file. Then select a flake URI that corresponds to one of the directory names within the hosts directory. For instance, we will opt for `vmware`.

```bash
git clone https://github.com/dsymbol/nixcfg
cd nixcfg
nixos-install --flake .#vmware
reboot
```

## Dynamic Nature of the Repository

It is important to note that this repository is designed to support my personal NixOS system and is subject to frequent updates and modifications as the needs of the system evolve over time. As a result, you can expect changes to occur regularly, and these updates may impact the configuration and functionality of the system.

## Acknowledgements

I highly recommend checking out [Baitinq](https://github.com/Baitinq/nixos-config)'s repository as he has been a valuable resource throughout my NixOS journey. Many thanks to Baitinq for his contributions and assistance.
