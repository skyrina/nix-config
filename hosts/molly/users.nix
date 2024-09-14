{
  pkgs,
  me,
  ...
}: {
  users.mutableUsers = false;

  users.users = {
    root = {
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
      initialHashedPassword = "$y$j9T$iIbcAAjcFCjPuLcQIDiVc0$LzlxYuq8HpLYSF9sYO1OEbV8k88T4CNRrP4g8yb2Yv9";
      openssh.authorizedKeys.keys = [
        me.pubkeys.saturday
        me.pubkeys.phone
      ];
      extraGroups = ["wheel" "docker" "caddy"];
    };
  };
}
