{pkgs, ...}: {
  home.packages = [
    (pkgs.factorio.override {
      username = "skyrina";
      token = builtins.readFile ../../../secrets/factorio_token;
      versionsJson = ./versions.json;
    })
  ];
}
