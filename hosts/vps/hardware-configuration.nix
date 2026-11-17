{
  # Update these UUIDs after reinstalling with disko, before the first deploy.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f222513b-ded1-49fa-b591-20ce86a2fe7f";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
  };
  boot.loader.grub.device = "/dev/vda";
}
