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

  time.timeZone = "Europe/Brussels";

  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;

  services.xserver = {
    enable = true;

    windowManager.herbstluftwm.enable = true;

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

  hardware.rtl-sdr.enable = true;

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
          ctrlp
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

  environment.systemPackages = with pkgs; [
    firefox
    fish
    wget
    fd

    cargo
    rustc
    rust-analyzer

    go
    gopls

    git
    gnumake
    alejandra

    herbstluftwm
    pavucontrol
    alacritty
    feh
    maple-mono
    powertop
    rofi
    htop
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.11";
}
