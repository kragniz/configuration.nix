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

  networking.hostName = "lambda-loli";
  networking.networkmanager.enable = true;
  networking.extraHosts = "192.168.100.102 example.local";
  
  powerManagement.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
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

    (texLiveAggregationFun { paths = [ texLive texLiveExtra texLiveBeamer lmodern ]; })
  ];

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;
    fonts = [
       pkgs.terminus_font
       pkgs.kochi-substitute-naga10
    ];
  };
  
  programs.bash.enableCompletion = true;


  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "kragniz" ];

  services = {
    xserver = {
      enable = true;
      layout = "us";

      #displayManager.gdm.enable = true;
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

  users.extraUsers.kragniz = {
    group = "users";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    home = "/home/kragniz";
    createHome = true;
    useDefaultShell = true;
    password = "hunter2";
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
}
