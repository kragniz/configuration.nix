{
  config,
  pkgs,
  ...
}: let
  persist = path: {
    mountPoint = path;
    device = "/persist" + path;
    noCheck = true;
    options = [
      "bind"
      "X-fstrim.notrim"
      "x-gvfs-hide"
    ];
    depends = ["/persist"];
    neededForBoot = true;
  };
in {
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/c95bbd9f-6c61-4b55-80df-00051ebe7524";
    }
  ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/2CC1-57C3";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
        "umask=0077"
      ];
    };

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["size=4G" "mode=755"];
    };

    "/persist" = {
      device = "UUID=30b3ebbd-8d8f-4331-bca2-9781591e2612";
      neededForBoot = true;
      fsType = "bcachefs";
    };

    # TODO: make this less repetitive
    "/home" = persist "/home";
    "/nix" = persist "/nix";
    "/var/log" = persist "/var/log";
    "/var/lib/nixos" = persist "/var/lib/nixos";
    "/var/lib/systemd/coredump" = persist "/var/lib/systemd/coredump";
    "/etc/NetworkManager/system-connections" = persist "/etc/NetworkManager/system-connections";
    "/etc/machine-id" = persist "/etc/machine-id";
    "/var/lib/upower" = persist "/var/lib/upower";
    "/var/lib/fwupd" = persist "/var/lib/fwupd";
    "/var/lib/flatpak" = persist "/var/lib/flatpak";
  };

  # don't fail because /etc/machine-id is bind mounted
  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

  # Add a little util for finding files which might need to be persisted
  environment.systemPackages = with pkgs; [
    (
      writeShellApplication {
        name = "find-ephemeral-files";
        runtimeInputs = [fd];
        text = ''
          sudo ${fd}/bin/fd --one-file-system --base-directory / --type f --hidden --exclude "{tmp,etc/passwd,etc/sudoers}"
        '';
      }
    )
  ];
}
