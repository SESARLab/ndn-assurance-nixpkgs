{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith ( pkgs // self );
  self = {
    ndn-cxx-assurance = callPackage ./ndn-cxx {};
    nfd-assurance = callPackage ./NFD {};
    ndn-tools-assurance = callPackage ./ndn-tools {};
    ndn-certification-agent = callPackage ./ndn-certification-agent {};
  };
in self
