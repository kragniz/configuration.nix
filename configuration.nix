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
    kernelPackages = pkgs.linuxPackages_4_15;
  };

  networking = {
    hostName = "tachibana";
    networkmanager.enable = false;
  };
  
  powerManagement.enable = false;

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

      # email
      mutt
      gnupg
      gnupg1compat

      # apps
      mpv
      screenfetch
      chromium
      firefox
      tor-browser-bundle-bin
      inkscape
      file
      wine
      gnome3.file-roller
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
    libvirtd.enable = false;
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      layout = "gb";

      xrandrHeads = [
        {
          output = "LVDS1";
          monitorConfig = ''
            Option "ignore" "true"
          '';
        }
        {
          output = "VGA1";
          primary = true;
          monitorConfig = ''
            Option "Rotate" "right"
          '';
        }
        {
          output = "HDMI1";
          monitorConfig = ''
            Option "Rotate" "right"
            Option "RightOf" "VGA1"
          '';
        }
      ];

      screenSection = "Monitor \"multihead3\"";

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
      enable = false;

      # Cambridge
      latitude = "52.2053";
      longitude = "0.1218";
    };
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
      ];
      home = "/home/kgz";
      createHome = true;
      useDefaultShell = true;
      password = "hunter2";
      uid = 1001;
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
