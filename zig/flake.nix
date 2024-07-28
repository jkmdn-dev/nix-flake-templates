{
  description = "Zig flake template";

  inputs = {
    nixpkgs = { url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz"; };
    zig-overlay = { url = "github:mitchellh/zig-overlay"; };
  };

  outputs = { self, nixpkgs, zig-overlay }:
    let
      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (final: prev:
                  let
                    zig = zig-overlay.packages.${system}.master;
                  in { inherit zig; })
              ];
            };
          });
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell { packages = with pkgs; [ nil nixfmt zig ];  
          shellHook = ''
            zig build build-zls --release=fast
          '';

        };
      });
    };
}
