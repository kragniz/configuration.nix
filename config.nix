{
  packageOverrides = pkgs: with pkgs; {
    openstackDev = pkgs.myEnvFun {
        name = "openstack-dev";
        buildInputs = [
          python
          python27Packages.pip
          python27Packages.tox
          stdenv
          pkgconfig
        ];
    };
  };
}
