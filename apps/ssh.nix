{ config, pkgs, lib, ... }:

{
	

  programs.ssh = {
  	enable = true;
  	extraConfig = "Host github\n	HostName github.com\n	IdentityFile=~/.ssh/msfoote_general_key";
  };
}
