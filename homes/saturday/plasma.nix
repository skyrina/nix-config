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
        acceleration = -0.60;
        accelerationProfile = "none";
        enable = true;
        leftHanded = false;
        middleButtonEmulation = false;
        name = "Razer Razer Viper";
        naturalScroll = false;
        productId = "0078";
        scrollSpeed = 1;
        vendorId = "1532";
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
