
{lib, stdenv, fetchurl, autoPatchelfHook
, ffmpeg }:

stdenv.mkDerivation rec {
  name = "stash-0.4.0-59";

  src = fetchurl {
    url = "https://github.com/stashapp/stash/releases/download/latest_develop/stash-linux";
    sha256 = "06r2h3z89w3kvjpkhy7mr9n9rkw7rpq2pi576aq362wxf3kbk3hn";
  };

  buildInputs = [ ffmpeg ];
  sourceRoot = ".";
  
  nativeBuildInputs = [
    autoPatchelfHook
  ];

  unpackPhase = ''
    
  '';

  installPhase = ''
    install -m755 -D $src $out/bin/stash
  '';
}
