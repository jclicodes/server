{
  description = "My NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    
    # sops-nix 
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, sops-nix, ... }: {
    nixosConfigurations = {
      shitbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # NixOS modules
        modules = [
          ./nixos/configuration.nix
          ./nixos/vim.nix
        ];

        specialArgs = {
          inherit sops-nix;
        };
      };
    };
  };
}
