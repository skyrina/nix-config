{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      {
        directory = "/etc/nixos";
        user = "user";
      }
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/libvirt"
      "/var/lib/docker"
      "/var/lib/ollama"
      {
        directory = "/var/lib/archisteamfarm";
        user = "archisteamfarm";
        group = "archisteamfarm";
      }
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    users.user = {
      directories = [
        "source"

        "Desktop"
        "Music"
        "Pictures"
        "Documents"
        "Videos"

        "Monero"

        ".cache"
        ".mozilla/firefox/Default"
        ".vscode"
        ".docker"
        ".gradle"
        ".wine"
        ".factorio"
        # TODO: figure out if having a global installation of rust is bad
        ".rustup"
        ".cargo/registry"
        ".kube"
        ".cloudflared"

        ".config/StardewValley"
        ".config/r2modman"
        ".config/r2modmanPlus-local"
        ".config/syncthing"
        ".config/Code"
        ".config/JetBrains"
        ".config/discord"
        ".config/zsh"
        ".config/vesktop"
        ".config/Element"
        ".config/blender"
        ".config/Yubico"
        ".config/YouTube Music"
        ".config/helm"
        ".config/wlxoverlay"
        ".config/Signal"
        ".config/unityhub"

        "Unity"
        "Zomboid"

        ".local/share/zsh"
        ".local/share/Trash"
        ".local/share/waydroid"
        ".local/share/direnv"
        ".local/share/Steam"
        # ".local/share/in.cinny.app" # deleted
        ".local/share/Celeste/Saves"
        ".local/share/qBittorrent"
        ".local/state/wireplumber"
        ".local/share/PrismLauncher"
        ".local/share/nushell"
        ".local/share/lutris"
        ".local/share/anime-game-launcher"
        ".local/share/kwalletd" # for signal
        ".local/share/Colossal Order" # cities skylines

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
      ];
      files = [];
    };
  };

  programs.fuse.userAllowOther = true;
}
