# Devpod (fork)
{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "devpod";
  version = "0.25.0";

  src = fetchurl {
    url = "https://github.com/skevetter/devpod/releases/download/v${version}/devpod-linux-amd64";
    sha256 = "sha256-OlCPrxrc57yYCl0z+FFfTqJ8Ifxzplc2QsvlduA/ApI=";
  };

  dontUnpack = true;
  phases = ["installPhase" "postInstall"];
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/devpod
    chmod +x $out/bin/devpod
  '';
  postInstall = ''
    mkdir -p $out/share/fish/vendor_completions.d
    $out/bin/devpod completion fish > $out/share/fish/vendor_completions.d/devpod.fish
  '';
}
