return {
  -- Désactiver les onglets (bufferline)
  { "akinsho/bufferline.nvim", enabled = false },

  -- Désactiver les icônes si tu veux
  { "nvim-tree/nvim-web-devicons", enabled = true },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false, -- le texte inline
        signs = true, -- Garde les signes marge
        underline = true, -- Garde soulignement
        update_in_insert = true, -- update en insertion
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
    "folke/snacks.nvim",
    opts = {
      -- Désactiver les barres verticales d'indentation
      indent = {
        enabled = false, -- Désactiver complètement
        -- Ou personnaliser :
        -- char = "│",     -- Changer le caractère
        -- highlight = "Comment",  -- Changer la couleur
      },
      -- Désactiver aussi les autres fonctionnalités si besoin
      scope = {
        enabled = false, -- Barres de scope
      },
    },
  },
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
}
