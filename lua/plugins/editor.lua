-- ============================================================
-- Misc editor extras
-- ============================================================

local gh = require('config.pack').gh

-- Extended treesitter-based textobjects
-- NOTE: overlaps with mini.ai (in plugins/ui.lua), which also provides
-- around/inside textobjects. Keeping both isn't harmful, just some redundancy.
vim.pack.add { gh 'nvim-treesitter/nvim-treesitter-textobjects' }
require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true, -- jump forward to the closest textobject if not currently inside one
    selection_modes = {
      ['@function.outer'] = 'V', -- linewise for whole function
      ['@function.inner'] = 'V',
    },
  },
}

local select = require 'nvim-treesitter-textobjects.select'
vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end)

-- [[ mini.nvim ]] - collection of small independent plugins/modules
vim.pack.add { gh 'nvim-mini/mini.nvim' }

if vim.g.have_nerd_font then
  require('mini.icons').setup()
  -- Backwards compatibility shim for plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
  MiniIcons.mock_nvim_web_devicons()
end

-- Better Around/Inside textobjects, e.g. `va)`, `yiiq`, `ci'`
require('mini.ai').setup {
  custom_textobjects = {
    -- Handled by treesitter instead
    f = false,
    c = false,
    a = false
  },
  n_lines = 500,
}

-- Add/delete/replace surroundings (brackets, quotes, etc.), e.g. `saiw)`, `sd'`, `sr)'`
require('mini.surround').setup()

require('mini.pairs').setup {
  modes = { insert = true, command = false, terminal = false },
  mappings = {
    ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
    ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
    ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

    [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
    [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
    ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

    ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
    ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
    ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
  },
}
require('mini.comment').setup()

-- Floating terminal and color editor
vim.pack.add {
  gh 'nvzone/floaterm',
  gh 'nvzone/volt',
}
require('floaterm').setup {
  border = false,
}
vim.keymap.set('n', '<c-\\>', '<cmd>FloatermToggle<CR>')
vim.keymap.set('t', '<c-\\>', '<cmd>FloatermToggle<CR>')

-- Markdown, LaTeX
vim.pack.add { gh 'OXY2DEV/markview.nvim' }
