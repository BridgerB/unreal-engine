{
  description = "Unreal Engine 5 for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        unreal-engine = pkgs.callPackage ./unreal-engine.nix {};
      in
      {
        packages = {
          default = unreal-engine;
          unreal-engine = unreal-engine;
        };

        apps = {
          default = {
            type = "app";
            program = "${unreal-engine}/bin/unreal-engine";
          };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ unreal-engine ];
          buildInputs = with pkgs; [
            # Development tools
            git
            cmake
            ninja
            clang
            gcc
          ];
          
          shellHook = ''
            echo "Unreal Engine 5 development environment"
            echo "Run: nix run . # to launch UE5"
            echo "Or: unreal-engine # if installed"
          '';
        };
      });
}