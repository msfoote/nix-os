{ config, pkgs, lib, ... }:

{
	home.packages = [
		pkgs.neofetch
	];	

	# home.activation = {
	# 	myActivationAction = lib.hm.dag.entryAfter ["installPackages"] ''
 #  			run --silence ${config.home.path}/bin/micro -plugin install filemanager
 #  			run --silence ${config.home.path}/bin/micro -plugin install manipulator
 #    	'';
 #   	};
}
