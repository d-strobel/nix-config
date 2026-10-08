{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "devsy";
  version = "1.19.0";

  src = fetchurl {
    url = "https://github.com/devsy-org/devsy/releases/download/v${version}/devsy-linux-amd64";
    sha256 = "sha256-L0PyirWzmbN5CRrrCWKOxrcNyCISpk0w3o4qShiknvU=";
  };

  dontUnpack = true;
  phases = ["installPhase" "postInstall"];
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/devsy
    chmod +x $out/bin/devsy
  '';
  postInstall = ''
    mkdir -p $out/share/fish/vendor_completions.d
    $out/bin/devsy completion fish > $out/share/fish/vendor_completions.d/devsy.fish
  '';
}
