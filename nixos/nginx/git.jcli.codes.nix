{ config, pkgs, ... }: {
  config = {
    sops.secrets.git_server_basic_auth = {
      owner = "nginx";
      group = "nginx";
    };

    services.nginx.virtualHosts."git.jcli.codes" = {
      sslCertificate = "/etc/nixos/secrets/jcli.codes.pem";
      sslCertificateKey = "/etc/nixos/secrets/jcli.codes.key";
      forceSSL = true;
      basicAuthFile = "/run/secrets/git_server_basic_auth";
      locations."/" = {
        proxyPass = "http://localhost:3000";
        extraConfig = ''
          client_max_body_size 512M;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Connection $http_connection;
          proxy_set_header Upgrade $http_upgrade;
        '';
      };
    };
  };
}
