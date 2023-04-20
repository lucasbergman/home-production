{
  description = "Nix configuration for my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];
    pkgsFor = nixpkgs.legacyPackages;
  in rec {
    formatter = forAllSystems (system: pkgsFor.${system}.alejandra);

    devShells =
      forAllSystems (system:
        import ./shell.nix {pkgs = pkgsFor.${system};});

    nixosConfigurations = {
      cheddar = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hosts/cheddar/configuration.nix
        ];
      };
    };
  };
}
