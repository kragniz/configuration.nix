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

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    tmux
    firefox
  ];
  
  programs.bash.enableCompletion = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";

    #windowManager.default = "xmonad";
    #windowManager.xmonad.enable = true;
    #windowManager.xmonad.enableContribAndExtras = true;
    #displayManager.gdm.enable = true;
    #desktopManager.xfce.enable = true;

    displayManager.auto.enable = true;
    desktopManager.gnome3.enable = true;
  };
  
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  users.mutableUsers = false;
  users.extraUsers.kragniz = {
    group = "users";
    extraGroups = [ "wheel" "networkmanager" ];
    home = "/home/kragniz";
    createHome = true;
    useDefaultShell = true;
    password = "hunter2";
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}