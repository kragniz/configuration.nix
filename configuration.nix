{
  config,
  lib,
  pkgs,
  ...
}: let
  readPasswordFile = path: lib.removeSuffix "\n" (builtins.readFile path);
in {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./users.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "chinatsu";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/London";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    alejandra
    cargo
    firefox
    fish
    git
    gnumake
    wget
    fd
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11";
}
