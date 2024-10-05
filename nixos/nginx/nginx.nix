{ config, pkgs, lib, ... }: 

with lib;

{
  imports = [
    ./git.jcli.codes.nix
    ./jcli.codes.nix
    ./www.jcli.codes.nix
  ];

  config = {
    # sops.secrets.ssl.cert = {
    #   owner = "nginx";
    #   group = "nginx";
    # };

    services.nginx = {
      enable = true;
      user = "nginx";
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
    };
  };
}
