{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device = "/dev/sda";
  };

  networking = {
    hostName = "lambda-loli";
    networkmanager.enable = true;
    extraHosts = "192.168.100.102 example.local";
  };
  
  powerManagement.enable = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/London";

  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  environment = {
    shells = [
      "${pkgs.bash}/bin/bash"
      "${pkgs.fish}/bin/fish"
    ];
    variables = {
      BROWSER = pkgs.lib.mkOverride 0 "chromium";
      EDITOR = pkgs.lib.mkOverride 0 "vim";
    };
    systemPackages = with pkgs; [
      # $ nix-env -qaP | grep wget to find packages
      vim
      tmux
      firefox
      git
      mosh

      mutt
      gnupg
      gnupg1compat

      mpv
      mplayer
      gnumake
      screenfetch
      vagrant
      docker
      python
      python34
      python35
      pythonPackages.docker_compose
      chromium
      inkscape

      #(texLiveAggregationFun { paths = [ texLive texLiveExtra texLiveBeamer lmodern ]; })
    ];
    gnome3 = {
      packageSet = pkgs.gnome3_18;
    };
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;
    fonts = [
       pkgs.terminus_font
       pkgs.kochi-substitute-naga10
    ];
  };
  
  programs = {
    bash = {
      enableCompletion = true;
    };
    ssh = {
      startAgent = true;
    };
  };

  virtualisation = {
    libvirtd.enable = false;
    virtualbox.host.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";

      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };
    tlp = {
      enable = true;
    };
    openssh = {
      enable = true;
    };
  };

  hardware.trackpoint.emulateWheel = true;

  users = {
    extraGroups.vboxusers.members = [ "kragniz" ];
    extraUsers.kragniz = {
      group = "users";
      extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
      home = "/home/kragniz";
      createHome = true;
      useDefaultShell = true;
      password = "hunter2";
      uid = 1000;
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
