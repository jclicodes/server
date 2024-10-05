{ config, pkgs, ... }: {
  config.services.nginx.virtualHosts."jcli.codes" = {
    root = "/var/www/jcli.codes";
      sslCertificate = "/etc/nixos/secrets/jcli.codes.pem";
      sslCertificateKey = "/etc/nixos/secrets/jcli.codes.key";
    forceSSL = true;

    locations."/pizzadle/" = {
      alias = "/var/www/jcli.codes/pizzadle/releases/03-10-2024/public/";
      index = "index.html";
      tryFiles = "$uri $uri/ index.html";
      extraConfig = ''
        autoindex on;
      '';
    };
  };
}

