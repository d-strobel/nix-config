# Microsandbox (based on nixpkgs PR #523829)
{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libcap_ng,
}:
stdenv.mkDerivation rec {
  pname = "microsandbox";
  version = "0.7.7";

  src = fetchurl {
    url = "https://github.com/superradcompany/microsandbox/releases/download/v${version}/microsandbox-linux-x86_64.tar.gz";
    sha256 = "sha256-s8xKXj9S392Tim9nrEqalZ3f4wS6tW3klkBEuGE/Abs=";
  };

  sourceRoot = ".";
  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [libcap_ng stdenv.cc.cc.lib];
  appendRunpaths = ["${placeholder "out"}/lib"];

  installPhase = ''
    install -Dm755 msb -t $out/bin
    ln -s msb $out/bin/microsandbox

    # bundled libkrunfw (e.g. libkrunfw.so.5.6.1)
    f=$(echo libkrunfw.so.*.*.*)
    install -Dm644 $f -t $out/lib
    abi=''${f#libkrunfw.so.}; abi=''${abi%%.*}
    ln -s $f $out/lib/libkrunfw.so.$abi
    ln -s libkrunfw.so.$abi $out/lib/libkrunfw.so
  '';

  # Runs after fixupPhase, so msb is already patched by autoPatchelfHook
  postPhases = ["completionPhase"];
  completionPhase = ''
    mkdir -p $out/share/fish/vendor_completions.d
    $out/bin/msb completion fish > $out/share/fish/vendor_completions.d/msb.fish
    # generator always emits `complete -c msb`, retarget it for the microsandbox symlink
    sed 's/complete -c msb /complete -c microsandbox /' \
      $out/share/fish/vendor_completions.d/msb.fish \
      > $out/share/fish/vendor_completions.d/microsandbox.fish
  '';
}
