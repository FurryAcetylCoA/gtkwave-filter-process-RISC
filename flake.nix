{
  outputs = inputs@{
    self, nixpkgs, flake-parts,
  }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    perSystem = { self', pkgs, ... }: {
      packages.default = pkgs.clangStdenv.mkDerivation {
        name = "gtkwave-filter";
        src = ./.;
        buildInputs = with pkgs; [
          llvmPackages.libllvm
        ];
        installPhase = ''
          mkdir -p $out/bin
          cp bin/* $out/bin
        '';
      };
      devShells.default = pkgs.mkShell {
        inputsFrom = [ self'.packages.default ];
        buildInputs = with pkgs; [];
        nativeBuildInputs = with pkgs; [];
      };
    };
  };
}
