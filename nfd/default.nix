{ pkgs ? import <nixpkgs> {}
, ndn-cxx
, withSystemd ? true
, withWebSocket ? true
, fetchFromGitHub
}:
let
  inherit (pkgs) lib stdenv mkShell fetchgit fetchgitPrivate openssl doxygen boost17x sqlite pkgconfig python3 python3Packages wafHook libpcap systemd;
  inherit (builtins) fetchGit;
  pname = "nfd";
  version = "0.7.1";

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "SESARLab";
    repo = pname;
    rev = "paper-Security-Certification-Scheme";
    sha256 = "1229sz9d61lns0kxri2y9h2y8sq93hm2smy73l62jicf8i7pwz7l";
    fetchSubmodules = withWebSocket;
  };

  nativeBuildInputs = [
    wafHook
    doxygen
    pkgconfig
    python3
    python3Packages.sphinx
  ];
  buildInputs = [ libpcap boost17x openssl ndn-cxx ] ++ lib.optional withSystemd systemd;

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
