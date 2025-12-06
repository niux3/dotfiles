-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- tabs
vim.keymap.set('n', 'nt', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', 'nq', '<cmd>tabclose<cr>', { 
  desc = 'Close Tab',
  remap = false,  -- Éviter la récursion
})
-- neo-tree
vim.keymap.set('n', '<f2>', '<cmd>Neotree reveal toggle<cr>', { desc = 'Open/Close Neotree' })
vim.keymap.set('n', '<leader>gg', '<cmd>!lazygit<cr>', { desc = 'Gitui' })
