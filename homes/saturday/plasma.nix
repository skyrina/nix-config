{pkgs, ...}: {
  home.packages = with pkgs; [
    catppuccin-cursors.mochaDark
    (catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    })
  ];

  # monitor config
  home.file.".config/kwinoutputconfig.json".source = ./kwinoutputconfig.json;

  programs.plasma = {
    enable = true;
    input.mice = [
      {
        acceleration = -0.50;
        accelerationProfile = "none";
        enable = true;
        leftHanded = false;
        middleButtonEmulation = false;
        name = "Keychron Keychron 4K Link";
        naturalScroll = false;
        productId = "3434";
        scrollSpeed = 1;
        vendorId = "d038";
      }
    ];
    kwin.effects.blur.enable = true;
    kwin.effects.translucency.enable = true;
    kwin.effects.wobblyWindows.enable = true;
    workspace.colorScheme = "CatppuccinMochaRed";
    workspace.wallpaper = ../../hosts/common/resources/starrynight.png;
    kscreenlocker.appearance.wallpaper = ../../hosts/common/resources/starrynight.png;
    panels = [
      {
        location = "bottom";
        floating = true;
        widgets = [
          {
            kickoff.icon = "nix-snowflake-white";
          }
          "org.kde.plasma.pager"
          {
            iconTasks = {
              launchers = [
                "applications:systemsettings.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:Alacritty.desktop"
                "applications:firefox-nightly.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {};
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              time.format = "24h";
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];
  };
}
