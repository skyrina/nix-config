{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = ["xhci_pci" "usbhid"];
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=4G"
        "defaults"
        "mode=755"
      ];
    };
    disk.sda = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            start = "513M"; # this works with 513 but fails with 512. annoying. should this be 501 instead of 513? idk.
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"]; # Override existing partition
              subvolumes = {
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime" "discard=async"];
                };
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = ["compress=zstd" "noatime" "discard=async"];
                };
              };
            };
          };
        };
      };
    };
  };
}
