{ lib
, multiStdenv
, stdenv_32bit
, cmake
}:

#multiStdenv.mkDerivation { #works fine, too
stdenv_32bit.mkDerivation {
  name = "cmake-nix";
  src = ./.;
  nativeBuildInputs = [ cmake ];
  installPhase = ''install -Dm755 $name $out/bin/$name'';
}
