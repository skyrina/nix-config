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
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/docker"
      "/var/lib/nomad" # TODO: remove

      # kubernetes
      "/var/lib/containerd"
      "/var/lib/rancher/k3s"

      # TODO: delete all of these (check last modified first tho, 19/11/24)
      # "/var/lib/kubernetes"
      # "/var/lib/kubelet"
      # "/etc/kube-flannel"
      # "/etc/kubernetes"
      # "/var/lib/etcd"
      # {
      #   directory = "/var/lib/cfssl";
      #   user = "cfssl";
      #   group = "cfssl";
      # }
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
        ".docker"
        "docker"

        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };

  programs.fuse.userAllowOther = true;
}
