{
  config,
  lib,
  ...
}: let
  readPasswordFile = path: lib.removeSuffix "\n" (builtins.readFile path);
in {
  users = {
    mutableUsers = false;

    users.kgz = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      initialHashedPassword = readPasswordFile ./kgz-password-hash;
    };

    users.root = {
      initialHashedPassword = readPasswordFile ./root-password-hash;
    };
  };
}
