{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./users.nix
  ];

  # Get 6.10-rc5 to fix https://bugzilla.kernel.org/show_bug.cgi?id=214649
  boot.kernelPackages = pkgs.linuxPackages_testing;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "chinatsu";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/London";

  services.xserver = {
    enable = true;
    # Replicate fix until https://github.com/NixOS/nixpkgs/pull/271198 is merged
    windowManager.session = lib.singleton {
      name = "herbstluftwm";
      start =
        ''
          ${pkgs.herbstluftwm}/bin/herbstluftwm &
          waitPID=$!
        '';
    };
    displayManager.gdm.enable = true;
    displayManager.gdm.debug = true;
    desktopManager.gnome.enable = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.fwupd.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        colorscheme rose-pine-dawn
        set number
        set expandtab
        set autoindent
        set tabstop=4
        set shiftwidth=4
        set list
        set listchars=tab:→\ ,nbsp:␣,trail:•

        lua <<EOF
          local cmp = require'cmp'

          cmp.setup({
            snippet = {
              expand = function(args)
                vim.snippet.expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
            }, {
              { name = 'buffer' },
            })
          })
        EOF
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          ctrlp
          rose-pine
          nvim-treesitter
          rustaceanvim
          nvim-cmp
          cmp-nvim-lsp
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    alejandra
    cargo
    firefox
    fish
    git
    gnumake
    wget
    fd
    herbstluftwm
    alacritty
    feh
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11";
}
