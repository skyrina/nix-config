{
  # me,
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
  ];

  # TODO: move almost everything that's below this to other files this sucks really bad fix it please

  # this is dumb but really useful
  # also takes like 5 seconds to enable sooo get commented out nerd
  # TODO: figure out if theres a way to make it take less time
  # boot.initrd.network.enable = true;
  # boot.initrd.availableKernelModules = ["igc"];
  # boot.kernelParams = ["ip=dhcp"];
  # boot.initrd.network.ssh = {
  #   enable = true;
  #   port = 23;
  #   shell = "/bin/cryptsetup-askpass";
  #   authorizedKeys = [me.pubkeys.laptop me.pubkeys.phone];
  #   hostKeys = [
  #     ./keys/initrd-rsa
  #     ./keys/initrd-ed25519
  #   ];
  # };

  networking.hostName = "strawberry";
  # FIXME: im too lazy to figure out what ports i need to open but stuff breaks if i enable it so i just disabled it
  networking.firewall.enable = false;
  networking.interfaces.eno1.wakeOnLan.enable = true;

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.kernelModules = ["amdgpu"];

  services.udev.extraRules = ''
    # keychron k12 pro
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="02c0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

    # keychron k12 pro dfu mode
    KERNEL=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0660", GROUP="users"
    KERNEL=="usb_device", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0660", GROUP="users"

    # lock screen on yubikey removal
    # TODO: make it have a 1 second delay since for some reason this gets triggered every time i do anything to my yubikey
    ACTION=="remove",\
      ENV{ID_BUS}=="usb",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_VENDOR}=="Yubico",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  services.pcscd.enable = true;

  security.pam.services = {
    login.u2fAuth = false;
    sudo.u2fAuth = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings.General.Experimental = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      user = import ../../homes/strawberry;
    };
  };

  # fix for tf2
  environment.systemPackages = with pkgs; [pkgsi686Linux.gperftools];

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true;
    };
  };

  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
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

  services = {
    syncthing = {
      enable = true;
      user = "user";
      dataDir = "/home/user/Documents";
      configDir = "/home/user/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          "phone".id = builtins.readFile ../../secrets/syncthing_phone_id;
        };
        folders = {
          "keepass" = {
            path = "/home/user/.cache/keepassxc/db";
            devices = ["phone"];
          };
        };
      };
    };
  };

  services.archisteamfarm.enable = true;
  services.archisteamfarm.web-ui.enable = true;

  programs.partition-manager.enable = true;

  programs.nix-ld.enable = true;

  # "minimum" amount of libraries needed for most games to run
  programs.nix-ld.libraries = with pkgs; [
    # common requirement for several games
    stdenv.cc.cc.lib

    # from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/games/steam/fhsenv.nix#L72-L79
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL
    libva

    # from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/games/steam/fhsenv.nix#L124-L136
    fontconfig
    freetype
    xorg.libXt
    xorg.libXmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    libdrm
    libidn
    tbb
    zlib
  ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  security.rtkit.enable = true;

  programs.adb.enable = true;
  # for MTP
  services.gvfs.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
