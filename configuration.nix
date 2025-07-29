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

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "chinatsu";
    networkmanager.enable = true;

    networkmanager.ensureProfiles.profiles = {
      "38C3" = {
        connection = {
          id = "38C3";
          type = "wifi";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "38C3";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-eap";
        };
        "802-1x" = {
          anonymous-identity = "38C3";
          eap = "ttls;";
          identity = "38C3";
          password = "38C3";
          phase2-auth = "pap";
          altsubject-matches = "DNS:radius.c3noc.net";
          ca-cert = "${builtins.fetchurl {
            url = "https://letsencrypt.org/certs/isrgrootx1.pem";
            sha256 = "sha256:1la36n2f31j9s03v847ig6ny9lr875q3g7smnq33dcsmf2i5gd92";
          }}";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
      };
    };

    firewall = {
      enable = true;

      allowedTCPPorts = [
      ];
    };
  };

  time.timeZone = "Europe/London";

  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;

  programs.niri.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver = {
    enable = true;
  };

  services.xserver.windowManager.herbstluftwm.enable = false;

  services.displayManager = {
    gdm.enable = true;
    gdm.debug = true;
  };


  services.desktopManager.gnome.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.fwupd.enable = true;

  hardware.rtl-sdr.enable = true;

  programs.steam.enable = true;

  services.flatpak.enable = true;

  services.openssh = {
    enable = false;
  };

  programs.ssh.startAgent = true;

  # TODO: disable the rest of gnome
  services.gnome.gcr-ssh-agent.enable = false;

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
          vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
          vim.g.mapleader = " "

          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
          vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
          vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

          vim.lsp.inlay_hint.enable(true, { 0 })

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
              { name = 'path' },
              { name = 'buffer' },
            })
          })

          local capabilities = require('cmp_nvim_lsp').default_capabilities()

          local lspconfig = require('lspconfig')
          lspconfig.rust_analyzer.setup({
            on_attach=on_attach,
            settings = {
              ["rust-analyzer"] = {
                imports = {
                  granularity = {
                    group = "module",
                  },
                  prefix = "self",
                },
                cargo = {
                  buildScripts = {
                    enable = true,
                  },
                },
                procMacro = {
                  enable = true
                },
                diagnostics = {
                  enable = true;
                },
              }
            }
          })
          lspconfig.gopls.setup{}
        EOF
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          telescope-nvim
          rose-pine
          nvim-treesitter
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
        ];
      };
    };
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # desktop bits
    alacritty
    arandr
    cheese
    chromium
    fd
    feh
    firefox
    chromium
    fish
    fractal
    htop
    amdgpu_top

    maple-mono.truetype-autohint

    mosh
    mpv
    yt-dlp
    nfs-utils
    pavucontrol
    powertop
    rofi
    usbutils
    wget
    gnome-screenshot
    brightnessctl
    dig
    aerc
    pwvucontrol
    wofi

    transmission_4-gtk

    # wayland
    swaybg
    foot
    neofetch
    xwayland-satellite

    # dev
    alejandra
    cargo
    git
    gnumake
    go
    gopls
    python3
    ruff
    rust-analyzer
    rustc
    uv
    vscode.fhs
    socat
    opentofu
    flatpak-builder
    inter
    ffmpeg-full
    qemu
    jq
    ripgrep

    linuxPackages_latest.perf
    hotspot

    # fosdem stuff
    krb5
    opensshWithKerberos
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11";
}
