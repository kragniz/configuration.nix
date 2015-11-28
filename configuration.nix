{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "lambda-loli";
  networking.networkmanager.enable = true;
  
  powerManagement.enable = true;
  services.tlp.enable = true;

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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  virtualisation.libvirtd.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";

    #displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
  };
  
  services.avahi = {
    enable = true;
    nssmdns = true;
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
