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
      # vim
      vim_configurable
      tmux
      screen
      firefox
      git
      mosh
      fish

      gnome3.gnome_terminal

      mutt
      gnupg
      gnupg1compat

      mpv
      gnumake
      screenfetch
      python
      python36
      chromium
      inkscape
      file

      wine

    ];
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;
    fonts = [
       pkgs.terminus_font
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
    docker.enable = false;
    virtualbox.host.enable = false;
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
      enable = true;
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
