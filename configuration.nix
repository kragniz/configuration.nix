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
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "tachibana";
    /*extraHosts = ''
      127.0.0.1 tachibana
      127.0.0.1 news.ycombinator.com
      127.0.0.1 twitter.com
      127.0.0.1 reddit.com
      127.0.0.1 www.reddit.com
    '';*/

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

      # dev
      vim_configurable
      emacs
      tmux
      tree
      screen
      git
      mosh
      fish
      vscode

      python
      python36
      go
      dep
      gnumake
      minikube
      kubectl

      # desktop
      gnome3.gnome_terminal
      gnome3.gnome-screenshot
      gnome3.nautilus
      gnome3.eog
      gnome3.dconf
      i3lock-color
      feh
      rofi
      powertop

      # email
      mutt
      gnupg
      gnupg1compat

      # apps
      mpv
      lollypop
      signal-desktop
      evince

      ncmpcpp
      imagemagick  # for album art
      mpc_cli

      screenfetch
      chromium
      firefox
      #tor-browser-bundle-bin
      inkscape
      blender
      file
      wineStaging
      playonlinux
      gnome3.file-roller
      gimp
      darktable
    ];
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;
    fonts = [
       pkgs.terminus_font_ttf
       pkgs.tewi-font
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
    libvirtd.enable = true;
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      layout = "gb";

      windowManager = {
        herbstluftwm = {
          enable = true;
        };
      };
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };
    tlp = {
      enable = false;
    };
    openssh = {
      enable = true;
    };
    redshift = {
      enable = true;
    };
  };

  location = {
    # Bristol
    latitude = 51.4545;
    longitude = 2.5879;
  };

  hardware = {
    trackpoint.emulateWheel = true;

    # for steam
    opengl.driSupport32Bit = true;

    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
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
    extraUsers.kgz = {
      group = "users";
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "vboxusers"
        "dialout"
        "docker"
      ];
      home = "/home/kgz";
      createHome = true;
      useDefaultShell = true;
      password = "hunter2";
      uid = 1001;
    };
  };
}
