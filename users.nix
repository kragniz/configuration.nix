{
  config,
  lib,
  ...
}: let
  readPasswordFile = path: lib.removeSuffix "\n" (builtins.readFile path);
in {
  users = {
    mutableUsers = false;

    groups.nfs.gid = 70;

    users.kgz = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "nfs"
      ];
      initialHashedPassword = readPasswordFile ./kgz-password-hash;
    };

    users.root = {
      initialHashedPassword = readPasswordFile ./root-password-hash;
    };
  };
}
