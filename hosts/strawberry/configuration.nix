{
  me,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./disks.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    ./users.nix
    ../common/nix.nix

    # FIXME: stylix kde scale issue
    # ./stylix.nix
  ];

  # TODO: move almost everything that's below this to other files this sucks really bad fix it please

  # this is dumb but really useful
  boot.initrd.network.enable = true;
  boot.initrd.availableKernelModules = ["igc"];
  boot.kernelParams = ["ip=dhcp"];
  boot.initrd.network.ssh = {
    enable = true;
    port = 23;
    shell = "/bin/cryptsetup-askpass";
    authorizedKeys = [me.pubkeys.laptop me.pubkeys.phone];
    hostKeys = [
      ./keys/initrd-rsa
      ./keys/initrd-ed25519
    ];
  };

  networking.hostName = "strawberry";
  # FIXME: im too lazy to figure out what ports i need to open but stuff breaks if i enable it so i just disabled it
  networking.firewall.enable = false;

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.kernelModules = ["amdgpu"];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      user = import ../../homes/strawberry;
    };
  };

  # fix for tf2
  environment.systemPackages = with pkgs; [pkgsi686Linux.gperftools];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true;
    };
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.rtkit.enable = true;

  programs.adb.enable = true;
  # for MTP
  services.gvfs.enable = true;
  services.udev.packages = [pkgs.heimdall];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
