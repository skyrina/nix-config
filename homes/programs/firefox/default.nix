{
  inputs,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;
    profiles = {
      Default = {
        id = 0;
        settings = {
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
      };
      Old = {
        id = 1;
      };
    };
  };
}
