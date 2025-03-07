# nixcfg

This repository contains my personal NixOS configuration. By leveraging the declarative and reproducible nature of NixOS, I can maintain a deterministic system configuration that can be easily replicated. My configuration includes packages, system services, and user-level configuration files tailored to my needs and preferences.

## Installation

```bash
sudo su
git clone https://github.com/dsymbol/nixcfg
cd nixcfg
nix-shell ./shells/partition.nix
partition
exit
nixos-install --flake .#vmware
reboot
```

## Dynamic Nature of the Repository

It is important to note that this repository is designed to support my personal NixOS system and is subject to frequent updates and modifications as the needs of the system evolve over time. As a result, you can expect changes to occur regularly, and these updates may impact the configuration and functionality of the system.

## Acknowledgements

I highly recommend checking out [Baitinq](https://github.com/Baitinq/nixos-config)'s repository as he has been a valuable resource throughout my NixOS journey. Many thanks to Baitinq for his contributions and assistance.
