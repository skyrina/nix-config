{
  pkgs,
  me,
  ...
}: {
  users.mutableUsers = false;

  # TODO: figure out if this being here makes any difference than being in homes/saturday
  programs.dconf.enable = true;

  users.users = {
    root = {
      initialHashedPassword = "$y$j9T$EhZKJg11K8wrK/Bv3ez2K.$Mnaaw326Tqy.UGc2efmnlQjczJNRIY7cfraYlDQcD.A";
      openssh.authorizedKeys.keys = [
        me.pubkeys.saturday
        me.pubkeys.phone
      ];
    };

    user = {
      home = "/home/user";
      createHome = true;
      isNormalUser = true;
      description = "user";
      shell = pkgs.nushell;
      initialHashedPassword = "$y$j9T$JGcoTZJsNy.yFYApXisoV.$9IAQ7ItgOLJJM7wWuR1jXsVYjY3wuyJ2JckPDJCI0L.";
      openssh.authorizedKeys.keys = [
        me.pubkeys.saturday
        me.pubkeys.phone
      ];
      extraGroups = ["wheel" "networkmanager" "audio" "plugdev" "docker" "libvirtd" "gamemode"];
    };
  };
}
