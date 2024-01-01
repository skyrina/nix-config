{
  description = ":3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # stable.url = "github:nixos/nixpkgs/nixos-23.05"; # FIXME?

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:bluskript/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox = {
      url = "github:nix-community/flake-firefox-nightly?rev=7628824d41a06bd7f656fb49c62227435866dbd2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      # "aarch64-linux"
      # "i686-linux"
      "x86_64-linux" # i think this is the only one i need?
      # "aarch64-darwin"
      # "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # TODO: figure out if i need these
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      strawberry = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          me = import ./identities/user.nix;
        };
        modules = [
          # > Our main nixos configuration file <
          disko.nixosModules.disko
          # FIXME
          # inputs.stylix.nixosModules.stylix
          (import ./hosts/strawberry/configuration.nix)
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "user@strawberry" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          (import ./homes/strawberry)
        ];
      };
    };
  };
}
