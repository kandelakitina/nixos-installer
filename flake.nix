{
  description = "NixOS Installer using Gum";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs"; # Use NixOS packages
  };

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      # Define your package
      packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
        name = "nixos-installer"; # Name of the package
        src = ./.; # Source directory for the package

        buildInputs = [
          pkgs.bash # Bash shell for scripting
          pkgs.gum # Gum tool for interactive scripts
          pkgs.disko # Disko tool for disk management
        ];

        installPhase = ''
          mkdir -p $out/bin # Create the output directory
          cp bin/installer.sh $out/bin/nixos-installer # Copy the installer script to the output directory
          chmod +x $out/bin/nixos-installer # Make the installer script executable
        '';
      };

      # Make it runnable
      apps.default = {
        type = "app"; # Define the type as an application
        program =
          "${self.packages.x86_64-linux.default}/bin/nixos-installer"; # Path to the executable
      };
    };
}
