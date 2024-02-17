# stolen from https://github.com/bluskript/nix-config/blob/master/hosts/common/fonts.nix
{pkgs, ...}: {
  stylix.fonts = {
    serif = {
      package = pkgs.eb-garamond;
      name = "EB Garamond";
    };
    sansSerif = {
      package = pkgs.geist-font-sans;
      name = "Geist";
    };
    emoji = {
      package = pkgs.twitter-color-emoji;
      name = "Twitter Color Emoji";
    };
    monospace = {
      package = pkgs.geist-font-mono;
      name = "Geist Mono Code";
    };
  };

  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      # this fixes emoji stuff
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Geist"
          "Noto Sans CJK SC"
          "Twitter Color Emoji"
          "Symbols Nerd Font"
        ];
        serif = [
          "EB Garamond"
          "Noto Serif CJK SC"
          "Twitter Color Emoji"
          "Symbols Nerd Font"
        ];
        monospace = [
          "Geist Mono Code"
          "Noto Sans Mono CJK SC"
          "Twitter Color Emoji"
          "Symbols Nerd Font Mono"
        ];
      };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    # font packages that should be installed
    packages = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk
      iosevka-bin
      twitter-color-emoji
      inter
      eb-garamond
    ];
  };
}
