{
  description = "Haskell starter flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = { pkgs, ... }:
        let
          hsStarterSrc = pkgs.haskellPackages.callCabal2nix "hs-starter" ./. { };
          hsStarter = pkgs.haskell.lib.dontCheck hsStarterSrc;
        in
        {
          packages.default = hsStarter;

          checks.default = pkgs.haskell.lib.doCheck hsStarterSrc;

          apps.default = {
            type = "app";
            program = "${hsStarter}/bin/hs-starter";
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              ghc
              cabal-install
              haskell-language-server
            ];
          };
        };
    };
}
