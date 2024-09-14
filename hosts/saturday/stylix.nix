{pkgs, ...}: {
  stylix = let
    palette = ../common/themes/catppuccin-mocha.yml;
  in {
    base16Scheme = palette;
    image = ../common/resources/starrynight.png;

    polarity = "dark";

    # opacity = {
    #   applications = 0.8;
    #   desktop = 0.85;
    #   terminal = 0.8;
    # };

    fonts.sizes = {
      applications = 10;
      desktop = 8;
    };

    targets.gtk.enable = true;

    cursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "Catppuccin-Mocha-Dark";
      size = 24;
    };
  };
}
