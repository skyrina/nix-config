{pkgs ? (import ../nixpkgs.nix) {}}: {
  pp-nikkei-journal = pkgs.callPackage ./pp-nikkei-journal.nix {};
}
