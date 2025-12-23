-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- tabs
vim.keymap.set("n", "nt", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "nq", "<cmd>tabclose<cr>", {
  desc = "Close Tab",
  remap = false, -- Éviter la récursion
})
-- neo-tree
vim.keymap.set("n", "<f2>", "<cmd>Neotree reveal toggle<cr>", { desc = "Open/Close Neotree" })
vim.keymap.set("n", "<leader>gg", "<cmd>!lazygit<cr>", { desc = "Gitui" })

-- Quickfix navigation
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })

-- Bonus : Toggle quickfix
vim.keymap.set("n", "<leader>qq", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle quickfix" })
