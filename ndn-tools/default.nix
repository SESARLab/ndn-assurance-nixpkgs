{ pkgs ? import <nixpkgs> {}
, ndn-cxx
, fetchFromGitHub
}:
let
  inherit (pkgs) lib stdenv mkShell fetchgit openssl doxygen boost17x sqlite pkgconfig python3 python3Packages wafHook libpcap;
  inherit (builtins) fetchGit;
  version = "0.7.1";
  pname = "ndn-tools";
  boost = boost17x;

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "SESARLab";
    repo = pname;
    rev = "paper-Security-Certification-Scheme";
    sha256 = "1rm1lsbqw8l6flhvi21pi0nbksngdq2x6mn85nyr6a49294m7i81";
  };

  nativeBuildInputs = [ pkgconfig wafHook doxygen python3 python3Packages.sphinx ];
  buildInputs = [ ndn-cxx boost libpcap openssl ];

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
    # Building the tests is disabled by default, since we don't run the tests
    # later and building them adds ~14min to build time. ~ C.
    # "--with-tests"
  ];

  # Upstream's tests don't all pass!
  doCheck = false;
  checkPhase = ''
    LD_LIBRARY_PATH=build/ build/unit-tests
  '';

  # outputs = [ "dev" "out" ];

  meta = with lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Essential Tools";
    license = licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ sjmackenzie MostAwesomeDude ];
  };
}
