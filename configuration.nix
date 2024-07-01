{
  config,
  lib,
  pkgs,
  ...
}: {
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

  services.xserver = {
    enable = true;
    # Replicate fix until https://github.com/NixOS/nixpkgs/pull/271198 is merged
    windowManager.session = lib.singleton {
      name = "herbstluftwm";
      start =
        ''
          ${pkgs.herbstluftwm}/bin/herbstluftwm &
          waitPID=$!
        '';
    };
    displayManager.gdm.enable = true;
    displayManager.gdm.debug = true;
    desktopManager.gnome.enable = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.fwupd.enable = true;

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
    herbstluftwm
    alacritty
    feh
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11";
}
