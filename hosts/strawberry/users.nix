{
  pkgs,
  me,
  ...
}: {
  users.mutableUsers = false;

  # TODO: figure out if these being here makes any difference than being in homes/strawberry
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  virtualisation.docker.enable = true;

  users.users = {
    root = {
      initialHashedPassword = "$y$j9T$EhZKJg11K8wrK/Bv3ez2K.$Mnaaw326Tqy.UGc2efmnlQjczJNRIY7cfraYlDQcD.A";
      openssh.authorizedKeys.keys = [
        me.pubkeys.laptop
        me.pubkeys.phone
      ];
    };

    user = {
      home = "/home/user";
      createHome = true;
      isNormalUser = true;
      description = "user";
      shell = pkgs.zsh;
      initialHashedPassword = "$y$j9T$JGcoTZJsNy.yFYApXisoV.$9IAQ7ItgOLJJM7wWuR1jXsVYjY3wuyJ2JckPDJCI0L.";
      openssh.authorizedKeys.keys = [
        me.pubkeys.laptop
        me.pubkeys.phone
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "audio" "plugdev" "docker"];
    };
  };
}
