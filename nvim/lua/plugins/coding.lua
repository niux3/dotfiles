return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Optimisation de la réactivité brute
      opts.performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 200,
      }
      
      -- Ne déclencher l'auto-complétion qu'à partir de 2 caractères 
      -- (évite les lags sur la première lettre)
      opts.completion = {
        keyword_length = 2,
      }

      -- OPTIONNEL : Nettoyage des sources pour gagner en FPS
      -- On ne garde que l'essentiel (LSP, Buffer, Snippets)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500, keyword_length = 3 },
      })
    end,
  },
}
