-- ============================================================
-- Search & navigation (snacks.nvim)
-- Dashboard, explorer, pickers, indent guides, word highlighting
-- ============================================================

local gh = require('config.pack').gh

vim.pack.add { gh 'folke/snacks.nvim' }

require('snacks').setup {
  dashboard = {
    preset = {
      keys = {
        { icon = ' ', key = 'c', desc = 'Config', action = '<leader>oc' },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
      { section = 'keys', gap = 1, padding = 1 },
    },
  },

  explorer = {
    enabled = true,
    hidden = true,
    ignored = true,
  },
  picker = {
    enabled = true,
    sources = {
      files = { hidden = true},
      grep = { hidden = true},
      explorer = { hidden = true, ignored = true }
    }
  },
  indent = { enabled = true },
  words = { enabled = true },
}

vim.keymap.set('n', '<leader>bd', function()
  vim.cmd 'silent! %bd'
  require('snacks').dashboard()
end, { desc = 'Close all buffers, return to dashboard' })

Snacks.indent.enable()

Snacks.words.enable()
vim.keymap.set('n', ']]', function() Snacks.words.jump(vim.v.count1, true) end, { desc = 'Next Reference' })
vim.keymap.set('n', '[[', function() Snacks.words.jump(-vim.v.count1, true) end, { desc = 'Prev Reference' })

local picker = Snacks.picker

vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = '[E]xplorer' })
vim.keymap.set('n', '<leader>sh', function() picker.help() end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', function() picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function() picker.files() end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', function() picker.pickers() end, { desc = '[S]earch [S]elect Picker' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', function() picker.grep_word() end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function() picker.grep() end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', function() picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', function() picker.resume() end, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', function() picker.recent() end, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sc', function() picker.commands() end, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', function() picker.buffers() end, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sp', function() picker.projects() end, { desc = '[S]earch [P]rojects' })
vim.keymap.set('n', '<leader>sn', function() picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
vim.keymap.set('n', '<leader>st', function() picker.colorschemes() end, { desc = '[S]earch [T]hemes' })
vim.keymap.set('n', '<leader>/', function() picker.lines() end, { desc = '[/] Fuzzily search in current buffer' })

-- Live grep in open files only
vim.keymap.set('n', '<leader>s/', function()
  picker.grep {
    finder = 'buffers',
    buffers = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

