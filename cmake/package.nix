{ lib
, multiStdenv
, stdenv_32bit
, cmake
,stdenv
}:

#multiStdenv.mkDerivation { #works fine, too
stdenv.mkDerivation {
  name = "cmake-nix";
  src = ./.;
  
  nativeBuildInputs = [ cmake ];
  installPhase = ''install -Dm755 $name $out/bin/$name'';
}
