{
  description = ":3";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?rev=e9ee548d90ff586a6471b4ae80ae9cfcbceb3420"; # TODO: change to nixos-unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    catppuccin.url = "github:catppuccin/nix";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    firefox.url = "github:nix-community/flake-firefox-nightly?rev=d442478b1c0e0d89dad9072e75d593c061554c04";
    firefox.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    deploy-rs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          NIX_CONFIG = "experimental-features = nix-command flakes";
          nativeBuildInputs = with pkgs; [nix nixd git alejandra git-crypt pkgs.deploy-rs];
        };
      }
    );

    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    # nixosModules = import ./modules/nixos;
    # homeManagerModules = import ./modules/home-manager;

    deploy.nodes = let
      mkNode = hostname: config: system: {
        hostname = hostname;
        sshUser = "root";

        profiles.system.path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${config};
      };
    in {
      molly = mkNode "192.168.1.231" "molly" "x86_64-linux";
    };

    nixosConfigurations = {
      saturday = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          me = import ./identities/user.nix;
        };
        modules = [
          disko.nixosModules.disko
          inputs.catppuccin.nixosModules.catppuccin
          (import ./hosts/saturday/configuration.nix)
          {
            home-manager.users.user = {
              imports = [
                inputs.catppuccin.homeManagerModules.catppuccin
                inputs.plasma-manager.homeManagerModules.plasma-manager
              ];
            };
          }
        ];
      };
      molly = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          me = import ./identities/user.nix;
        };
        modules = [
          disko.nixosModules.disko
          (import ./hosts/molly/configuration.nix)
        ];
      };
    };

    homeConfigurations = {
      "user@saturday" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          me = import ./identities/user.nix;
        };
        modules = [
          inputs.catppuccin.homeManagerModules.catppuccin
          inputs.plasma-manager.homeManagerModules.plasma-manager
          (import ./homes/saturday)
        ];
      };
      "user@molly" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          me = import ./identities/user.nix;
        };
        modules = [
          (import ./homes/molly)
        ];
      };
    };
  };
}
