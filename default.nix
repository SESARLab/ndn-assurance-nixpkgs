{ system ? builtins.currentSystem }:

let
  # pkgs = import <nixpkgs> { inherit system; };
  pkgs = import (
    builtins.fetchTarball {
      name = "nixos-unstable-2021-05-26";
      url = "https://github.com/nixos/nixpkgs/archive/9b7fb215d4d8399772a4f3d6f00fab3747136f53.tar.gz";
      sha256 = "02d1841j7jg161q7cwh7vryxhv7x3bmnhd1jczx14ggfa66vqfhm";
      # sha256 = "0d1q48x18msbsbrsdhqmx1lpdnaf73ip023i8hgmbll69svq7rhh";
    }
  ) { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    ndn-cxx = callPackage ./ndn-cxx {};
    nfd = callPackage ./nfd {};
    ndn-tools = callPackage ./ndn-tools {};
    ndn-certification-agent = callPackage ./ndn-certification-agent {};
  };
in
self
