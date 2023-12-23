{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      import = [./catppuccin-mocha.yaml];
      size = 10;
    };
  };
}
