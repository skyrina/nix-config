{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  lock = pkgs.writeShellScript "lock" "${pkgs.swaylock}/bin/swaylock -fF";
in {
  home.packages = with pkgs; [
    wl-clipboard
    wofi
    wofi-emoji
  ];

  home.sessionVariables = {
    WLR_DRM_NO_MODIFIERS = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  programs.swaylock.enable = true;

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "exec ${lock}";
      }
    ];
    timeouts = [
      {
        timeout = 15;
        command = "exec ${lock}";
      }
    ];
  };

  services.mako = {
    enable = true;
    anchor = "bottom-right";
  };

  programs.wlogout.enable = true;

  wayland.windowManager.sway = {
    package = inputs.swayfx.packages.${pkgs.system}.default;
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty msg create-window || alacritty";
      menu = "${pkgs.wofi}/bin/wofi --show run";
      bars = [];
      input = {
        "type:pointer" = {
          accel_profile = "flat";
        };
      };
      output = {
        eDP-1 = {
          scale = "1";
          pos = "0 0";
          resolution = "1920x1080";
        };
      };
      keybindings = let
        cfg = config.wayland.windowManager.sway.config;
        mod = cfg.modifier;
      in
        lib.mkOptionDefault {
          "${mod}+space" = "exec ${cfg.menu}";
        };
    };
  };
}
