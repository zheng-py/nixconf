#ln -s ~/Insync/pierrez1984@gmail.com/Dropbox/mac_config/home-manager ~/.config
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in {
  home.username = "py";
  home.homeDirectory = "/Users/py";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    htop
    ripgrep
    glances
    bottom
    aria
    alacritty
    thefuck
    nerdfonts
    rclone
    syncthing
    nil
    pyright
    pylint
    luajitPackages.luacheck
    isort
    black
    lua-language-server
    marksman
    tree-sitter

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (python311.withPackages (p:
      with p; [
        numpy
        requests
        ipdb
        pudb
        pysnooper
        pyside6
      ]))
  ];
  #pkgs.python311.withPackages
  #(p:
  #with p; [
  #numpy
  #])
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/py/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "vim";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.git = {
    enable = true;
    userEmail = "pierrez1984@gmail.com";
    userName = "zh-py";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      bl = "sudo python3 ~/Downloads/osx_battery_charge_limit/main.py -s 42";
      bh = "sudo python3 ~/Downloads/osx_battery_charge_limit/main.py -s 77";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "thefuck"
        "z"
        "command-not-found"
        "poetry"
        "sudo"
        "terraform"
        "systemadmin"
      ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    withPython3 = true;
    extraConfig = ''
      colorscheme gruvbox
      syntax enable
      set mouse=a
      set number
      set wrap
      set linebreak
      set clipboard=unnamed
      set nu rnu
      let g:context_nvim_no_redraw = 1
      let &scrolloff = 5
      let g:context_enabled = 0
      filetype plugin indent on
      autocmd FileType python map <buffer> <F5> :w<CR>:exec 'term python3 %' shellescape(@%, 1)<CR>
      autocmd FileType python imap <buffer> <F5> <esc>:w<CR>:exec 'term python3 %' shellescape(@%, 1)<CR>
      autocmd Filetype lua setlocal tabstop=4
      autocmd Filetype lua setlocal shiftwidth=4
      au FileType python map <silent> <leader>b ofrom pudb import set_trace; set_trace()<esc>
      au FileType python map <silent> <leader>B Ofrom pudb import set_trace; set_trace()<esc>
      lua vim.opt.signcolumn = "yes"
      cnoremap <C-a> <Home>
      cnoremap <C-e> <End>
      cnoremap <C-p> <Up>
      cnoremap <C-n> <Down>
      cnoremap <C-b> <Left>
      cnoremap <C-f> <Right>
      cnoremap <C-d> <Del>
      cnoreabbrev <expr> tn getcmdtype() == ":" && getcmdline() == 'tn' ? 'tabnew' : 'tn'
      cnoreabbrev <expr> th getcmdtype() == ":" && getcmdline() == 'th' ? 'tabp' : 'th'
      cnoreabbrev <expr> tl getcmdtype() == ":" && getcmdline() == 'tl' ? 'tabn' : 'tl'
      cnoreabbrev <expr> te getcmdtype() == ":" && getcmdline() == 'te' ? 'tabedit' : 'te'
    '';
    plugins = with pkgs.vimPlugins; [
      vim-visual-multi
      gruvbox
      trouble-nvim
      fzf-vim
      context-vim
      vim-nix
      nerdcommenter
      #{
        #plugin = vimtex;
        #config = /* vim */ ''
          #let g:vimtex_mappings_enabled = 0
          #let g:vimtex_imaps_enabled = 0
          #let g:vimtex_view_method = 'zathura'
          #let g:vimtex_compiler_latexmk = {'build_dir': '.tex'}
          #nnoremap <localleader>f <plug>(vimtex-view)
          #nnoremap <localleader>g <plug>(vimtex-compile)
          #nnoremap <localleader>d <plug>(vimtex-env-delete)
          #nnoremap <localleader>c <plug>(vimtex-env-change)
        #'';
      #}
      markdown-preview-nvim
      {
        plugin = vim-markdown;
        config = /* vim */ ''
          let g:vim_markdown_folding_disabled = 1
          let g:vim_markdown_conceal = 0
          let g:vim_markdown_frontmatter = 1
          let g:vim_markdown_toml_frontmatter = 1
          let g:vim_markdown_json_frontmatter = 1
        '';
      }
      {
        plugin = nvim-lastplace;
        type = "lua";
        config = ''
          require('nvim-lastplace').setup()
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile(./neovim/lspconfig.lua);
      }
      {
        plugin = nvim-lint;
        type = "lua";
        config = ''
          require('lint').linters_by_ft = {
            python = {'pylint'},
            lua = {'luacheck'},
          }
          vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
              require("lint").try_lint()
            end,
          })
        '';
      }
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lua
      cmp-vsnip
      vim-vsnip
      friendly-snippets
      cmp-nvim-lsp
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile(./neovim/completion.lua);
      }
      plenary-nvim
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          require('mini.surround').setup()
          require('mini.trailspace').setup()
        '';
      }
      {
        plugin = harpoon2;
        type = "lua";
        config = ''
          local harpoon = require("harpoon")
          harpoon:setup()
          vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
          vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
          vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
          vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
          vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
          vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
          vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
          vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
        '';
      }
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require("nvim-web-devicons").setup()
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
          require("telescope").setup{}
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          local function metals_status()
            return vim.g["metals_status"] or ""
          end
          require('lualine').setup(
            {
              options = {
                theme = 'everforest',
                icon_enabled = true,
              },
              sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff' },
                lualine_c = { 'filename', metals_status },
                lualine_x = {'encoding', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'},
              }
            }
          )
        '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            highlight = { enable = true},
            indent = { enable = true},
          })
        '';
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require('ibl').setup({
            indent = {
              char = "┊",
            },
            scope = {
              enabled = true,
              show_start = true,
              show_end = true,
            },
          })
        '';
      }
      {
        plugin = treesj;
        type = "lua";
        config = ''
          require('treesj').setup{
            lang = {
              lua = require('treesj.langs.lua'),
              typescript = require('treesj.langs.typescript'),
              python = require('treesj.langs.python'),
              },
            use_default_keymaps = true,
            check_syntax_error = true,
            max_join_length = 120,
            cursor_behavior = 'hold',
            notify = true,
            dot_repeat = true,
            on_error = nil,
            }
        '';
      }
    ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };
      window = {
        #padding.x = 10;
        #padding.y = 10;
        dynamic_padding = true;
        opacity = 0.95;
        decorations = "buttonless";
        startup_mode = "Maximized";
      };
      font = {
        size = 16.0;
        normal.family = "FiraCode Nerd Font";
        bold.family = "FiraCode Nerd Font";
        italic.family = "FiraCode Nerd Font";
      };
      cursor = {
        style.shape = "Beam";
        style.blinking = "On";
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      shell = {
        program = "zsh";
        args = [
          "-l"
        ];
      };
      colors = {
        primary = {
          background = "0x1b182c";
          foreground = "0xcbe3e7";
        };
        normal = {
          black = "0x100e23";
          red = "0xff8080";
          green = "0x95ffa4";
          yellow = "0xffe9aa";
          blue = "0x91ddff";
          magenta = "0xc991e1";
          cyan = "0xaaffe4";
          white = "0xcbe3e7";
        };
        bright = {
          black = "0x565575";
          red = "0xff5458";
          green = "0x62d196";
          yellow = "0xffb378";
          blue = "0x65b2ff";
          magenta = "0x906cff";
          cyan = "0x63f2f1";
          white = "0xa6b3cc";
        };
      };
    };
  };

  #home.activation = mkIf pkgs.stdenv.isDarwin {
  #copyApplications = let
  #apps = pkgs.buildEnv {
  #name = "home-manager-applications";
  #paths = config.home.packages;
  #pathsToLink = "/Applications";
  #};
  #in
  #lib.hm.dag.entryAfter ["writeBoundary"] ''
  #baseDir="$HOME/Applications/Home Manager Apps"
  #if [ -d "$baseDir" ]; then
  #rm -rf "$baseDir"
  #fi
  #mkdir -p "$baseDir"
  #for appFile in ${apps}/Applications/*; do
  #target="$baseDir/$(basename "$appFile")"
  #$DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
  #$DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
  #done
  #'';
  #};
}
