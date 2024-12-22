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
          "widget.gtk.non-native-titlebar-buttons.enabled" = false; # https://github.com/catppuccin/firefox/issues/18#issuecomment-2547337372
        };
      };
    };
  };
}
