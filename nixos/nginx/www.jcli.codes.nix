{ config, pkgs, ... }: {
  config.services.nginx.virtualHosts."www.jcli.codes" = {
      sslCertificate = "/etc/nixos/secrets/jcli.codes.pem";
      sslCertificateKey = "/etc/nixos/secrets/jcli.codes.key";
    forceSSL = true;

    extraConfig = ''
      return 301 https://jcli.codes$request_uri;
    '';
  };
}
