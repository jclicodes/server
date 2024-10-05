{
  lib,
  config,
  pkgs,
  sops-nix,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./nginx/nginx.nix
    sops-nix.nixosModules.sops
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  # section: Secrets
  sops = {
    defaultSopsFile = ../secrets.yaml;
    # validateSopsFile = false;

    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  # section: Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # section: Network
  networking.hostName = "shitbox";
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  hardware.bluetooth.enable = false;

  # section: Time & Localization
  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # section: User config
  users.users.jcli = {
    isNormalUser = true;
    description = "Jake";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ sops ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEws0C5BIAlQzsjz1/lm1FzuM3cvdgyTr5Y1hEf3dy54 jake@jcli.codes"
    ];
  };
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEws0C5BIAlQzsjz1/lm1FzuM3cvdgyTr5Y1hEf3dy54 jake@jcli.codes"
    ];
  };
  services.getty.autologinUser = "jcli";

  # section: Environment
  environment.variables = {
    EDITOR = "${pkgs.vim}/bin/vim";
    VISUAL = "${pkgs.vim}/bin/vim";
  };

  # section: Packages
  environment.systemPackages = with pkgs; [
    curl
    wget
    parted
    git
    docker-compose # TODO: Switch to arion
  ];

  # section: System services
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
    };
  };


  # TODO: configure ddclient for cloudflare
  # services.ddclient = {
  #   enable = false;
  #   configFile = "/var/lib/ddclient/secrets/ddclient.conf";
  # };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/mnt/storage";
    };
  };

  # section: Firewall
  networking.firewall.allowedTCPPorts = [ 80 222 443 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  # section: Misc.
  swapDevices = [
    { device = "/var/swapfile"; size = 4 * 1024; }
  ];

  console.keyMap = "us";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
