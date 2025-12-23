return {
  -- Désactiver les onglets (bufferline)
  { "akinsho/bufferline.nvim", enabled = false },

  -- Désactiver les icônes si tu veux
  { "nvim-tree/nvim-web-devicons", enabled = true },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Garde ta config diagnostics
      opts.diagnostics = {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = true,
      }

      -- AJOUTE les auto-imports
      opts.servers = opts.servers or {}

      -- TypeScript/JavaScript
      opts.servers.ts_ls = {
        settings = {
          typescript = {
            inlayHints = { enabled = false },
            preferences = {
              importModuleSpecifierPreference = "relative",
            },
          },
          javascript = {
            inlayHints = { enabled = false },
            preferences = {
              importModuleSpecifierPreference = "relative",
            },
          },
        },
      }

      -- Python avec Pyright (sera installé automatiquement)
      opts.servers.pyright = {
        enabled = false,
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "basic", -- ou "off" / "strict"
            },
          },
        },
      }
      opts.servers.pylsp = {
        enabled = true,
        settings = {
          pylsp = {
            plugins = {
              rope_autoimport = {
                enabled = true,
              },
            },
          },
        },
      }
      opts.servers.emmet_language_server = {
        enabled = true,
      }
      opts.servers.emmet_ls = {
        enabled = false,
      }

      return opts
    end,
  },

  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        menu = {
          auto_show = true,
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            name = "LSP",
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                -- Filtrer toutes les suggestions d'Emmet
                local source = (item.source_name or ""):lower()
                return not source:match("emmet")
              end, items)
            end,
          },
        },
      },
    },
  },
  -- {
  --   "mattn/emmet-vim",
  --   ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "xml" },
  --   init = function()
  --     -- Configuration AVANT le chargement du plugin
  --     vim.g.user_emmet_mode = "inv" -- insert, normal, visual
  --     vim.g.user_emmet_leader_key = "<C-e>" -- Ctrl+E, pour expand
  --     vim.g.user_emmet_install_global = 0 -- Pas d'installation globale
  --
  --     -- Settings pour JSX/TSX
  --     vim.g.user_emmet_settings = {
  --       javascript = {
  --         extends = "jsx",
  --       },
  --       typescript = {
  --         extends = "tsx",
  --       },
  --       javascriptreact = {
  --         extends = "jsx",
  --       },
  --       typescriptreact = {
  --         extends = "tsx",
  --       },
  --     }
  --   end,
  --   config = function()
  --     -- Active Emmet seulement pour les filetypes spécifiques
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  --       callback = function()
  --         vim.cmd("EmmetInstall")
  --       end,
  --     })
  --   end,
  -- },
  -- PYMPLE pour les imports Python (comme PyCharm)
  {
    "alexpasmantier/pymple.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    build = ":PympleBuild",
    config = function()
      require("pymple").setup({
        add_import_to_buf = true,
        logging = {
          enabled = false,
        },
      })
    end,
    keys = {
      {
        "<leader>ci",
        function()
          require("pymple").add_import()
        end,
        desc = "Add Python import",
        ft = "python",
      },
      {
        "<leader>cI",
        function()
          require("pymple").organize_imports()
        end,
        desc = "Organize Python imports",
        ft = "python",
      },
      {
        "<leader>cu",
        function()
          require("pymple").remove_unused_imports()
        end,
        desc = "Remove unused imports",
        ft = "python",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "autopep8" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      -- Format automatiquement à la sauvegarde
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  -- surround
  {
    "nvim-mini/mini.surround",
    opts = {
      -- Config options si besoin
      mappings = {
        add = "ys", -- Add surrounding
        delete = "ds", -- Delete surrounding
        find = "", -- Find surrounding
        find_left = "",
        highlight = "",
        replace = "cs", -- Change surrounding
        update_n_lines = "",
      },
    },
  },
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<C-e>", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },
  -- CtrlP
  {
    "kien/ctrlp.vim",
    config = function()
      -- Configuration similaire à ancien .vimrc
      vim.g.ctrlp_custom_ignore = {
        dir = [[\v[\/]\.?(git|__pycache__|idea|vsc|vscode|hg|svn|node_modules|venv)$]],
        file = [[\v\.(exe|so|dll|pyc)$]],
      }

      -- Configuration supplémentaire pour de meilleures performances
      vim.g.ctrlp_use_caching = 0
      vim.g.ctrlp_clear_cache_on_exit = 0
      -- vim.g.ctrlp_cache_dir = vim.fn.expand('~/.cache/ctrlp')

      -- Utiliser fd si disponible pour plus de rapidité
      -- if vim.fn.executable('fd') == 1 then
      --   vim.g.ctrlp_user_command = 'fd --type f --color=never "" %s'
      --   vim.g.ctrlp_user_command_caching = 1
      -- end
    end,
    keys = {
      -- Remplacer <space><space> par CtrlP
      { "<C-p>", "<cmd>CtrlP<cr>", desc = "CtrlP" },
      { "<leader>p", "<cmd>CtrlP<cr>", desc = "CtrlP" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        commands = {
          -- Commande personnalisée si besoin
        },
      },
      window = {
        mappings = {
          ["s"] = "split_with_window_picker",
          ["v"] = "vsplit_with_window_picker",
          ["S"] = "open_split",
          ["V"] = "open_vsplit",
        },
      },
    },
  },
  { "nvim-neo-tree/neo-tree.nvim", enabled = true },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        filetypes = {
          "css",
          "javascript",
          "html",
          "lua",
          "vim",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "astro",
          "xml",
          "markdown",
          "php",
          "python",
          "scss",
          "less",
          "json",
          "yaml",
        },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = false, -- Ne pas afficher les noms (red, blue)
          RRGGBBAA = true,
          AARRGGBB = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "background", -- Fond coloré
          virtualtext = "", -- Icône carrée
          -- virtualtext = '■',    -- Alternative
          always_update = true, -- Mise à jour en temps réel
        },
        -- Tous les formats supportés :
        buftypes = {
          "*",
          "!prompt",
          "!popup",
        },
      })

      -- Activer immédiatement pour tous les buffers ouverts
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Désactiver indent et scope
      opts.indent = { enabled = false }
      opts.scope = { enabled = false }

      -- Dashboard
      opts.dashboard = {
        preset = {
          header = [[
 ███╗   ██╗██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██║   ██║██║████╗ ████║
 ██╔██╗ ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
        },
      }

      return opts
    end,
  },
}
