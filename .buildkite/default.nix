{
  nixpkgs ? import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs-channels/archive/929768261a3ede470eafb58d5b819e1a848aa8bf.tar.gz";
  sha256 = "0zi54vbfi6i6i5hdd4v0l144y1c8rg6hq6818jjbbcnm182ygyfa";
  }) {}
}:

with nixpkgs;

stdenv.mkDerivation {
  name = "canva-tfsec-build";
  buildInputs = [
    git
    go
  ];
}
