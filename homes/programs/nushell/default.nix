{
  pkgs,
  config,
  ...
}: {
  programs.nushell = {
    enable = true;
    extraConfig = let
      nu_scripts = "${pkgs.nu_scripts}/share/nu_scripts";
    in ''
      ${builtins.readFile ./config.nu}
      use ${nu_scripts}/modules/nix/nix.nu *
    '';
    extraEnv = ''
      $env.HOME = '${config.home.homeDirectory}'
      $env.HISTFILE = '${config.home.homeDirectory}/.local/share/nushell/history'
    '';
  };
}
