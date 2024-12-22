{ config, pkgs, ... }: {
  networking.firewall.allowedTCPPorts = [ 6443 ];

  services.k3s = {
    enable = true;
    role = "server";

    extraFlags = [
      "--node-label svccontroller.k3s.cattle.io/enablelb=true" # turn load balancer into allowlist mode, in case i'll add more nodes in the future
      "--tls-san 10.0.0.1"
      "--tls-san 192.168.1.231"
      "--tls-san home.nyaa.bar"
      "--disable traefik"
      # "--disable servicelb" # maybe replace with something else?
      # "--disable-cloud-controller" # option can be enabled with the one above
      # "--disable local-storage" # FIXME: replace with ceph then disable
      "--cluster-cidr 10.42.0.0/16,2001:cafe:42::/56"
      "--service-cidr 10.43.0.0/16,2001:cafe:43::/112"
    ];
  };
}