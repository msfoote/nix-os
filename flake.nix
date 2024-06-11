{

	description = "msfoote's NixOS Flake";

	inputs = {
		##################### Official NixOS and HM Package Sources #####################

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		hardware.url = "github:nixos/nixos-hardware";

		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		#################### Utilities ####################

	    # Declarative partitioning and formatting
	    disko = {
	      url = "github:nix-community/disko";
	      inputs.nixpkgs.follows = "nixpkgs";
	    };

	    # Secrets management. See ./docs/secretsmgmt.md
	    sops-nix = {
	      url = "github:mic92/sops-nix";
	      inputs.nixpkgs.follows = "nixpkgs";
	    };

	    # vim4LMFQR!
	    nixvim = {
	      #url = "github:nix-community/nixvim/nixos-23.11";
	      url = "github:nix-community/nixvim";
	      inputs.nixpkgs.follows = "nixpkgs-unstable";
	    };
		
	};

	outputs = inputs@{ self, nixpkgs, home-manager, ... }:
	let
		# --- SYSTEM SETTINGS --- #
		systemSettings = {
			system = "x86_64-linux"; # System Architecture
			hostname = "nixos-test"; # Hostname
			profile = "personal";
			timezone = "America/Phoenix";
			locale = "en_US.UTF-8";
			bootMode = "uefi";
			bootMountPath = "/boot";
			grubDevice = "";
		};

		# ----- USER SETTINGS ----- #
		userSettings = rec {
			username = "msfoote"; # username
			name = "Matthew"; # name/identifier
			email = "matthew.foote@gmail.com"; # email (used for certain configurations)
			dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
			theme = "uwunicorn-yt"; # selcted theme from my themes directory (./themes/)
			wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
			# window manager type (hyprland or x11) translator
			wmType = if (wm == "hyprland") then "wayland" else "x11";
			browser = "qutebrowser"; # Default browser; must select one from ./user/app/browser/
			defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
			term = "alacritty"; # Default terminal command;
			font = "Intel One Mono"; # Selected font
			fontPkg = pkgs.intel-one-mono; # Font package
			editor = "emacsclient"; # Default editor;
			# editor spawning translator
			# generates a command that can be used to spawn editor inside a gui
			# EDITOR and TERM session variables must be set in home.nix or other module
			# I set the session variable SPAWNEDITOR to this in my home.nix for convenience
			spawnEditor = if (editor == "emacsclient") then
				"emacsclient -c -a 'emacs'"
				else
					(if ((editor == "vim") ||
					(editor == "nvim") ||
					(editor == "nano")) then
					"exec " + term + " -e " + editor
				else
					editor);
		};

		lib = nixpkgs.lib;
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in {
		nixosConfigurations = {
			nixos-test = lib.nixosSystem {
				inherit system;
				modules = [ ./configuration.nix ];
				specialArgs = {
					inherit systemSettings;
					inherit userSettings;
				};
			};
		};

		homeConfigurations = {
			msfoote = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./home.nix
				];
				extraSpecialArgs = {
					inherit systemSettings;
					inherit userSettings;
				};
			};
		};
	};

}
