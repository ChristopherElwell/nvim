-- ============================================================
-- Git
-- ============================================================

local gh = require('config.pack').gh

vim.pack.add { gh 'kdheepak/lazygit.nvim' }
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = '[G]it ([G]ui via lazygit)' })
