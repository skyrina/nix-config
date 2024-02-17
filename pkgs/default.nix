{pkgs ? (import ../nixpkgs.nix) {}}: {
  geist-font-sans = pkgs.callPackage ./geist-font-sans.nix {};
  geist-font-mono = pkgs.callPackage ./geist-font-mono.nix {};
}
