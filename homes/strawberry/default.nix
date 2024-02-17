{
  outputs,
  nixosConfig,
  pkgs,
  ...
}: {
  imports = [
    ../programs/nushell
    ../programs/starship.nix
    ../programs/firefox
    ../programs/alacritty
    ../programs/factorio
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "user";
    homeDirectory = "/home/user";
    shellAliases = nixosConfig.environment.shellAliases;
    packages = with pkgs; [
      (pkgs.discord.override {
        withVencord = true;
      })
      vesktop
      cinny-desktop

      # TODO: figure out if having a global installation of rustup and gcc is bad
      rustup
      gcc

      git-crypt
      ncdu

      wineWowPackages.stable

      qbittorrent

      vscode
      jetbrains.idea-community
      jetbrains.datagrip

      (steam.override {
        # fix for tf2
        extraLibraries = pkgs: [pkgs.gperftools];
      })
      steam-run
      prismlauncher

      blender
      aseprite # TODO: make the config file declarative
      osu-lazer
      keepassxc
      r2modman
      yubikey-personalization
      yubikey-manager-qt
      nix-output-monitor

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      catppuccin-cursors.mochaDark
    ];
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # temp fix until https://github.com/nix-community/home-manager/issues/4804 is fixed
  services.gpg-agent.pinentryFlavor = "qt";

  services.gnome-keyring.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "skyrina";
    userEmail = "sorryu02@gmail.com";
    lfs.enable = true;
  };
  programs.bash.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
