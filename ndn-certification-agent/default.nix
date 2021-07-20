{ lib
, stdenv
, cargo
, ndn-cxx
, ndn-tools
, nfd
, rustc
, rustPlatform
, fetchFromGitHub
}:

let
  ndnsec = "${ndn-cxx}/bin/ndnsec";
  nfdc = "${nfd}/bin/nfdc";
in
rustPlatform.buildRustPackage rec {
  version = "1.1.0";
  pname = "ndn-certification-agent";

  nativeBuildInputs = [ cargo rustc ];
  buildInputs = [ ndn-tools nfd ];

  src = fetchFromGitHub {
    owner = "SESARLab";
    repo = pname;
    rev = "paper-Security-Certification-Scheme";
    sha256 = "0ya76ym10ziacnalv2niv9wzh1kvspydbiy5fgcccsiyabrkq9g7";
  };

  patchPhase = ''
      substituteInPlace ./src/command/ndnsec/mod.rs --replace /usr/bin/ndnsec ${ndnsec}
      substituteInPlace ./src/command/nfdc.rs       --replace /usr/bin/nfdc   ${nfdc}
  '';

  # postPatch = ''
  #   substituteInPlace $src/src/command/ndnsec/mod.rs --replace '/usr/bin/ndnsec' '${ndnsec}'
  #   substituteInPlace $src/src/command/nfdc.rs --replace '/usr/bin/nfdc' '${nfdc}'
  # '';

  doCheck = true;

  cargoSha256 = "sha256:1rmfq6ypkb7571j38463869i5gr3w83ny59h1pxf9hf5zl4y7zhv";

  # cargoBuildFlags = "--bin ca";

  meta = with lib; {
    # homepage = "http://named-data.net/";
    # description = "A Named Data Neworking (NDN) or Content Centric Networking (CCN) abstraction";
    # license = licenses.lgpl3;
    platforms = lib.platforms.unix;
    # maintainers = with maintainers; [ sjmackenzie MostAwesomeDude ];
  };
}
