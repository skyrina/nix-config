{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      import = [./catppuccin-mocha.toml];
      font.size = 10;
    };
  };
}
