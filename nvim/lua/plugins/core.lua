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
        enabled = true,
        settings = {
          python = {
            analysis = {
              indexing = true,
              importFormat = "absolute",
              exclude = { "**/node_modules", "**/__pycache__" },
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              -- diagnosticMode = "workspace",
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
        enabled = false,
      }
      opts.servers.emmet_ls = {
        enabled = false,
      }
      opts.servers.html = {
        enabled = false,
      }
      -- Désactive le LSP CSS
      opts.servers.cssls = {
        enabled = false,
      }
      -- Alternative : certains utilisent 'css_ls' comme nom
      opts.servers.css_ls = {
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
        -- AJOUTE CECI : <C-e> cache blink ET laisse passer la touche
        ["<C-e>"] = { "hide", "fallback" },
      },
      completion = {
        menu = {
          auto_show = function()
            -- Désactive blink UNIQUEMENT pour html et css
            local disabled = { "html", "css", "scss" }
            local ft = vim.bo.filetype
            local should_disable = vim.tbl_contains(disabled, ft)
            -- vim.notify("Filetype: " .. ft .. " | Disabled: " .. tostring(should_disable), vim.log.levels.INFO, { title = "Blink Debug" })
            return not should_disable
          end,
        },
        -- AJOUTE CECI : empêche l'insertion automatique intrusive
        list = {
          selection = {
            -- Ne présélectionne rien automatiquement
            preselect = false,
            -- N'insère jamais automatiquement sans validation
            auto_insert = false,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "codecompanion" },
        providers = {
          lsp = {
            name = "LSP",
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                local source = (item.source_name or ""):lower()
                -- Filtre SEULEMENT emmet, pas html
                return not source:match("emmet")
              end, items)
            end,
          },
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
          },
        },
      },
    },
  },
  {
    "mattn/emmet-vim",
    ft = {
      "html",
      "css",
      "scss",
      "jinja",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "xml",
    },
    init = function()
      -- Configuration AVANT le chargement du plugin
      vim.g.user_emmet_mode = "inv" -- insert, normal, visual
      vim.g.user_emmet_leader_key = "<C-e>" -- Ctrl+e, pour expand
      vim.g.user_emmet_install_global = 0 -- Pas d'installation globale

      -- Settings pour JSX/TSX
      vim.g.user_emmet_settings = {
        javascript = {
          extends = "jsx",
        },
        typescript = {
          extends = "tsx",
        },
        javascriptreact = {
          extends = "jsx",
        },
        typescriptreact = {
          extends = "tsx",
        },
      }
    end,
    config = function()
      -- Active Emmet seulement pour les filetypes spécifiques
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "html",
          "css",
          "scss",
          "jinja",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
        },
        callback = function()
          vim.cmd("EmmetInstall")
        end,
      })
    end,
  },

  -- PYMPLE pour les imports Python (comme PyCharm)
  -- {
  --   "alexpasmantier/pymple.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   build = ":PympleBuild",
  --   config = function()
  --     require("pymple").setup({
  --       add_import_to_buf = true,
  --       logging = {
  --         enabled = false,
  --       },
  --     })
  --   end,
  --   keys = {
  --     {
  --       "<leader>ci",
  --       function()
  --         require("pymple").add_import()
  --       end,
  --       desc = "Add Python import",
  --       ft = "python",
  --     },
  --     {
  --       "<leader>cI",
  --       function()
  --         require("pymple").organize_imports()
  --       end,
  --       desc = "Organize Python imports",
  --       ft = "python",
  --     },
  --     {
  --       "<leader>cu",
  --       function()
  --         require("pymple").remove_unused_imports()
  --       end,
  --       desc = "Remove unused imports",
  --       ft = "python",
  --     },
  --   },
  -- },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "autopep8" },
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
      formatters = {
        prettier = {
          prepend_args = { "--tab-width", "4" },
        },
      },
    },
  },
  {
    "evanleck/vim-svelte",
    branch = "main",
    init = function()
      -- On définit les variables AVANT le chargement du plugin
      vim.g.svelte_indent_script = 0
      vim.g.svelte_indent_style = 0
    end,
  },
  -- surround
  {
    "echasnovski/mini.surround",
    enabled = false,
    opts = {
      -- Config options si besoin
      mappings = {
        add = "os", -- Add surrounding
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
    "tpope/vim-surround",
    init = function()
      -- Remplace les mappings par défaut
      vim.g.surround_no_mappings = 1 -- désactive tous les mappings par défaut
    end,
    config = function()
      vim.keymap.set("n", "os", "<Plug>Ysurround", { desc = "Add surrounding" })
      vim.keymap.set("n", "oss", "<Plug>Yssurround", { desc = "Add surrounding line" })
      vim.keymap.set("n", "ds", "<Plug>Dsurround", { desc = "Delete surrounding" })
      vim.keymap.set("n", "cs", "<Plug>Csurround", { desc = "Change surrounding" })
      vim.keymap.set("x", "os", "<Plug>VSurround", { desc = "Add surrounding (visual)" })
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
    "preservim/tagbar",
    enabled = true,
  },
  {
    "nvim-mini/mini.animate",
    enabled = false,
  },
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-a>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = { cpp = true },
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
        log_level = "off", -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false, -- disables built in keymaps for more manual control
        condition = function()
          return vim.env.NVIM_SUPERMAVEN_DISABLE
        end,
      })
      vim.cmd("SupermavenUseFree!") -- Utilise le mode "Free" par défaut. Le ! permet de ne pas afficher le message de confirmation. Mais affichera une erreur au démarrage.
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "supermaven-inc/supermaven-nvim" },
    keys = {
      { "<tab>", false, mode = { "i", "s" } },
      { "<s-tab>", false, mode = { "i", "s" } },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        http = {
          nvidia_nim = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://integrate.api.nvidia.com",
                api_key = "NVIDIA_API_KEY",
              },
              schema = {
                model = {
                  default = "nvidia/nemotron-3-super-120b-a12b",
                },
                max_tokens = {
                  default = 2048,
                },
              },
            })
          end,
          -- openrouter_gpt = function()
          --   return require("codecompanion.adapters").extend("openai_compatible", {
          --     env = {
          --       url = "https://openrouter.ai/api",
          --       api_key = "OPENROUTER_API_KEY",
          --       chat_url = "/v1/chat/completions",
          --     },
          --     schema = {
          --       model = { default = "openai/gpt-4o-mini" },
          --       max_tokens = { default = 2048 },
          --     },
          --   })
          -- end,
        },
      },
      interactions = {
        chat = { adapter = "nvidia_nim" },
        inline = { adapter = "nvidia_nim" },
      },
    },
  },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = "*",
  --   opts = {
  --     provider = "openrouter", -- 👈 Change le fournisseur par défaut
  --     debug = false,
  --     providers = {
  --       openrouter = {
  --         __inherited_from = "openai",
  --         endpoint = "https://openrouter.ai/api/v1",
  --         api_key_name = "OPENROUTER_API_KEY",
  --         model = "openai/gpt-4o-mini", -- ou "gemini-2.5-flash-preview-05-20"
  --         max_tokens = 4096,
  --         extra_request_body = {
  --           top_p = 0.9,
  --           temperature = 0.7,
  --         },
  --       },
  --     },
  --   },
  --   -- opts = {
  --   --   provider = "nvidia",
  --   --   providers = {
  --   --     nvidia = {
  --   --       __inherited_from = "openai",
  --   --       endpoint = "https://integrate.api.nvidia.com/v1",
  --   --       api_key_name = "NVIDIA_API_KEY",
  --   --       model = "nvidia/nemotron-3-super-120b-a12b",
  --   --       disable_tools = true,  -- Important : Nemotron ne supporte pas le Tool Use
  --   --       extra_request_body = {
  --   --         max_tokens = 4096,
  --   --       },
  --   --     },
  --   --   },
  --   -- },
  --   build = "make",
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --     {
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = { insert_mode = true },
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = { file_types = { "markdown", "Avante" } },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
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
 _______  _______________________   ____.___   _____   
 \      \ \_   _____/\_____  \   \ /   /|   | /     \  
 /   |   \ |    __)_  /   |   \   Y   / |   |/  \ /  \ 
/    |    \|        \/    |    \     /  |   /    Y    \
\____|__  /_______  /\_______  /\___/   |___\____|__  /
        \/        \/         \/                     \/ 
        ]],
        },
      }

      return opts
    end,
  },
}
