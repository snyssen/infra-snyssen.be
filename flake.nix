{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
          just
          pre-commit
          ansible
          ansible-lint
          glibcLocales # otherwise ansible cannot run
          d2
          grafana-alloy
        ];
      };
    }
  );
}
