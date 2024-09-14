{
  outputs,
  nixosConfig,
  pkgs,
  ...
}: {
  imports = [
    ../programs/nushell
    ../programs/firefox
    ../programs/factorio
    ./plasma.nix
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
      (pkgs.discord.override {withVencord = true;})
      vesktop
      element-desktop

      # TODO: figure out if having a global installation of rustup and gcc is bad
      rustup
      gcc

      bun

      git-crypt
      ncdu

      wineWowPackages.unstableFull

      qbittorrent

      vscode
      android-studio # TODO: add to impermanence
      jetbrains.idea-community
      jetbrains.datagrip

      (steam.override {
        extraLibraries = pkgs: [pkgs.gperftools pkgs.mono]; # gperftools: tf2
        extraPkgs = pkgs: [pkgs.gamescope pkgs.mono]; # mono: cities skylines 1
      })
      steam-run
      prismlauncher

      aseprite # TODO: make the config file declarative
      keepassxc
      r2modman
      lutris

      blender
      unityhub

      youtube-music
      # yubikey-personalization
      # yubikey-manager-qt
      # wlx-overlay-s
      # monero-gui
      signal-desktop
    ];
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  services.gnome-keyring.enable = true;

  # services.kdeconnect = {
  #   enable = true;
  #   indicator = true;
  # };

  services.arrpc.enable = true;

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

  programs.mpv = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.btop = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.obs-studio.enable = true;

  programs.alacritty = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      font.size = 10;
    };
  };

  programs.starship = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      nix_shell.format = "in [nix shell]($style) ";
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  xdg.enable = true;

  # nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
