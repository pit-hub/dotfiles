# On the terminal run: nix-shell
{ pkgs ? import <nixpkgs> {} }:


pkgs.mkShell {
  # Add the 'kind' package to the build inputs
  buildInputs = [
    pkgs.yq-go # yq is often packaged as `yq-go` in nixpkgs
    pkgs.jq # Powerful JSON processor
    pkgs.bat # `cat` clone with syntax highlighting
    pkgs.nano # A simple text editor
    pkgs.github-cli
  ];
}
