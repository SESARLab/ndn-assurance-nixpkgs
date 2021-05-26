{ pkgs ? import <nixpkgs> {},
  ndn-cxx-assurance ? import ../ndn-cxx {},
  withSystemd ? true,
  withWebSocket ? false # FIXME: can't init submodules
}:
let
  inherit (pkgs) lib stdenv mkShell fetchgit fetchgitPrivate openssl doxygen boost17x sqlite pkgconfig python3 python3Packages wafHook libpcap systemd;
  inherit (builtins) fetchGit;
  pname = "nfd-assurance";
  version = "0.7.1";

in stdenv.mkDerivation {
  inherit pname version;

  src = fetchGit {
    url = "ssh://git@gitlab.com/ndn-assurance/NFD.git";
    ref = "6770a23c494c7fb9039461a67987730a6a2fceaa";
  };

  nativeBuildInputs = [
    wafHook doxygen pkgconfig python3 python3Packages.sphinx
  ];
  buildInputs = [ libpcap boost17x openssl ndn-cxx-assurance ] ++ lib.optional withSystemd systemd;

  wafConfigureFlags = [
     "--boost-includes=${boost17x.dev}/include"
     "--boost-libs=${boost17x.out}/lib"
  ] ++ lib.optional (!withWebSocket) "--without-websocket";

  # Even though there are binaries, they don't get put in "bin" by default, so
  # this ordering seems to be a better one. ~ C.
  outputs = [ "out" "dev" ];
  meta = with lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Forwarding Daemon";
    license = licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ maintainers.MostAwesomeDude ];
  };
}


