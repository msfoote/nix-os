{ config, pkgs, lib, ...}:
let
	myAliases = {
		ll = "ls -l";
		".." = "cd ..";
		"garbage" = "sudo nix-collect-garbage --delete-older-than 7d";
		"nixhm" = "home-manager switch --flake ~/.dotfiles/";
		"nixos" = "sudo nixos-rebuild switch --flake ~/.dotfiles/";
	};
in
{
	programs.bash = {
		enable = true;
		shellAliases = myAliases;
		initExtra = "neofetch";
		bashrcExtra = ''
echo "This is a test"
echo "Hello World!"
		'';
	};

	programs.zsh = {
		enable = true;
		shellAliases = myAliases;
	};


}
