{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./disks.nix
    ./users.nix
    ../common/nix.nix
    ./impermanence.nix
    ../common/ca.nix
  ];

  networking.hostName = "molly";
  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  networking.nameservers = ["127.0.0.1"];

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout = 3;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      user = import ../../homes/molly;
    };
  };

  zramSwap.enable = true;

  environment.variables.BROWSER = "echo";
  environment.stub-ld.enable = false;

  services.openssh.enable = true;

  systemd = {
    enableEmergencyMode = false;
    watchdog = {
      runtimeTime = "20s";
      rebootTime = "30s";
    };
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };

  virtualisation.docker.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    dockerSocket.enable = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  fileSystems."/media" = {
    device = "/dev/disk/by-uuid/42359e33-177b-48c6-8adf-ed17786043a5";
    fsType = "btrfs";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
