{
  # me,
  pkgs,
  inputs,
  outputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.aagl.nixosModules.default
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    ./disks.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    ./users.nix
    ../common/nix.nix
    ../common/ca.nix
    # ./sunshine.nix
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

  networking.hostName = "saturday";
  networking.networkmanager.enable = true;
  # FIXME: im too lazy to figure out what ports i need to open but stuff breaks if i enable it so i just disabled it
  networking.firewall.enable = false;
  networking.interfaces.eno1.wakeOnLan.enable = true;
  networking.nameservers = ["1.1.1.1"];

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelParams = [
    "pcie_port_pm=off" # pcie power management issues on the x670e-e motherboard leading to random network disconnects
    "pcie_aspm.policy=performance" # this might not be needed
    # "radeon.dpm=0" # flickering
    # "amdgpu.sg_display=0" # flickering attempt 2
    # "amdgpu.dcdebugmask=0x612" # flickering attempt 3
    # "amdgpu.dcdebugmask=0x10" # flickering attempt 4, disable panel self refresh
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

  zramSwap.enable = true;

  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.opencl.enable = true;
  # hardware.amdgpu.amdvlk.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.udev.extraRules = ''
    # keychron k12 pro
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="02c0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

    # keychron k12 pro dfu mode
    KERNEL=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0660", GROUP="users"
    KERNEL=="usb_device", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0660", GROUP="users"

    # lock screen on yubikey removal
    # TODO: make it have a 1 second delay since for some reason this gets triggered every time i do anything to my yubikey
    # ACTION=="remove",\
    #   ENV{ID_BUS}=="usb",\
    #   ENV{ID_MODEL_ID}=="0407",\
    #   ENV{ID_VENDOR_ID}=="1050",\
    #   ENV{ID_VENDOR}=="Yubico",\
    #   RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"

    # wiimote pro
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0330", MODE="0666"

    # valve index cameras
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2400", MODE="0660", TAG+="uaccess"

    # pi pico serial
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="b00b", ATTRS{idProduct}=="cafe", MODE="0666"

    # wemos d1 mini
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666"

    # try to fix artifacts by forcing it to performance/high
    KERNEL=="card1", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="high"
  '';

  systemd.services.artifactWorkaround = {
    description = "Reset GPU power performance level on resume as a workaround for screen artifacts";
    wantedBy = ["post-resume.target"];
    after = ["post-resume.target"];

    script = ''
      echo auto > /sys/class/drm/card1/device/power_dpm_force_performance_level
      echo high > /sys/class/drm/card1/device/power_dpm_force_performance_level
    '';

    serviceConfig.Type = "oneshot";
  };

  security.pam.services = {
    login.u2fAuth = false;
    sudo.u2fAuth = true;
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  programs.gamemode.enable = true;

  # hell
  services.flatpak.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = lib.mkForce true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [oxygen];
  services.displayManager.defaultSession = "plasma";

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    # (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
    cozette
    pp-nikkei-journal
  ];

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  hardware.steam-hardware.enable = true;

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
      user = import ../../homes/saturday;
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

    lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  services.syncthing = {
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

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.0";
    # package = let
    #   version = "0.5.1";
    # in
    #   pkgs.ollama.overrideAttrs (old: {
    #     version = version;

    #     src = pkgs.fetchFromGitHub {
    #       owner = "ollama";
    #       repo = "ollama";
    #       rev = "v${version}";
    #       hash = "sha256-llsK/rMK1jf2uneqgon9gqtZcbC9PuCDxoYfC7Ta6PY=";
    #       fetchSubmodules = true;
    #     };
    #   });
  };
  systemd.services.ollama.serviceConfig.DynamicUser = lib.mkForce false;

  services.archisteamfarm.enable = true;
  services.archisteamfarm.web-ui.enable = true;

  programs.partition-manager.enable = true;

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  programs.anime-game-launcher.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.ovmf.packages = [pkgs.OVMFFull.fd];
    qemu.swtpm.enable = true;
  };
  virtualisation.waydroid.enable = true;
  programs.virt-manager.enable = true;

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };

  catppuccin.accent = "red";
  catppuccin.tty.enable = true;

  security.rtkit.enable = true;

  programs.adb.enable = true;
  # for MTP
  services.gvfs.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
