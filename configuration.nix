{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      grub.enable = true;
      grub.version = 2;
      grub.device = "/dev/sda";
    };
    kernelPackages = pkgs.linuxPackages_4_6;
  };

  networking = {
    hostName = "lambda-loli";
    networkmanager.enable = true;
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
    allowBroken = true; 

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
      # vim
      tmux
      firefox
      git
      mosh

      mutt
      gnupg
      gnupg1compat

      mpv
      mplayer
      #python35Packages.mps-youtube
      gnumake
      screenfetch
      vagrant
      python
      python34
      python35
      chromium
      inkscape
      file
      sshuttle

      wine

      vim_configurable

      #(texLiveAggregationFun { paths = [ texLive texLiveExtra texLiveBeamer lmodern ]; })
    ];
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;
    fonts = [
       pkgs.terminus_font
       pkgs.kochi-substitute-naga10
       pkgs.source-code-pro
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
    #docker.enable = true;
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
    redshift = {
      enable = true;

      # Cambridge
      latitude = "52.2053";
      longitude = "0.1218";
    };
  };

  hardware = {
    trackpoint.emulateWheel = true;

    # for steam
    opengl.driSupport32Bit = true;
    pulseaudio.support32Bit = true;
  };

  users = {
    extraUsers.kragniz = {
      group = "users";
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "vboxusers"
        "dialout"
      ];
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
