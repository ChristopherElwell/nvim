-- ============================================================
-- Basic keymaps & autocmds (no plugins involved)
-- ============================================================

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic config & keymaps. See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'if_many',
    wrap = true,
    max_width = 80
  },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = false,
  virtual_lines = false,

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
  desc = "Show diagnostic",
})

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode with <Esc><Esc> instead of the harder-to-discover <C-\><C-n>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier with CTRL+<hjkl>. See `:help wincmd`
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Vim config shortcuts
vim.keymap.set('n', '<leader>oc', function() vim.cmd('cd ' .. vim.fn.stdpath('config')) Snacks.picker.files()
end, { desc = 'Open Config Dir' })

-- Page up and down modification
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })

-- Save all and restart
vim.keymap.set('n', '<leader>rr', function() vim.cmd('wa') vim.cmd('restart') end, { desc = 'Save all and restart Nvim' })

-- Highlight when yanking (copying) text.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
