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

        ".cache"
        ".mozilla/firefox/Default"
        ".vscode"
        ".gradle"
        ".wine"
        # TODO: figure out if having a global installation of rust is bad
        ".rustup"
        ".cargo/registry"

        ".config/Code"
        ".config/JetBrains"
        ".config/discord"
        ".config/zsh"
        ".config/VencordDesktop"
        ".config/blender"

        ".local/share/zsh"
        ".local/share/Trash"
        ".local/share/direnv"
        ".local/share/Steam"
        ".local/state/wireplumber"
        ".local/share/PrismLauncher"

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
      files = [
        ".local/share/nushell/history"
      ];
    };
  };

  programs.fuse.userAllowOther = true;
}
