{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "ahci"
    "sd_mod"
    "sr_mod"
    "nvme"
  ];
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "net.ifnames=0"
    "biosdevname=0"
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    configurationLimit = 15;
  };
  boot.loader.efi.canTouchEfiVariables = false;

  services.qemuGuest.enable = true;
}
