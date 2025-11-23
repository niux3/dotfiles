return {
  -- Désactiver les onglets (bufferline)
  { "akinsho/bufferline.nvim", enabled = false  },

  -- Désactiver les icônes si tu veux
  { "nvim-tree/nvim-web-devicons", enabled = true  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,      -- Désactive le texte inline
        signs = true,              -- Garde les signes marge
        underline = true,          -- Garde soulignement
        update_in_insert = false,  -- Pas d'update en insertion
      }
    }
  },
  -- surround
  {
    "echasnovski/mini.surround",
    opts = {
      -- Config options si besoin
      mappings = {
        add = "ys",           -- Add surrounding
        delete = "ds",        -- Delete surrounding  
        find = "",            -- Find surrounding
        find_left = "",
        highlight = "",
        replace = "cs",       -- Change surrounding
        update_n_lines = "",
      }
    }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        commands = {
          -- Commande personnalisée si besoin
        }

      },
      window = {
        mappings = {
          ["s"] = "split_with_window_picker",
          ["v"] = "vsplit_with_window_picker", 
          ["S"] = "open_split",
          ["V"] = "open_vsplit",

        }
      }
    }
  },
  { "nvim-neo-tree/neo-tree.nvim", enabled = true  },
  {
    "folke/snacks.nvim",
    opts = {
      -- Désactiver les barres verticales d'indentation
      indent = {
        enabled = false,  -- Désactiver complètement
        -- Ou personnaliser :
        -- char = "│",     -- Changer le caractère
        -- highlight = "Comment",  -- Changer la couleur
      },
      -- Désactiver aussi les autres fonctionnalités si besoin
      scope = {
        enabled = false,  -- Barres de scope
      }
    }
  },
}
