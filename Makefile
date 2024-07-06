switch:
	sudo nixos-rebuild switch --flake path://#chinatsu

update:
	nix flake update

test:
	nix build path://#nixosConfigurations.chinatsu.config.system.build.vm
