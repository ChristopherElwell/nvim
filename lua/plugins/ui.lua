-- ============================================================
-- UI / core UX plugins
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules, lualine
-- ============================================================

local gh = require('config.pack').gh

-- Automatically detect and set indentation
vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

-- Git signs in the gutter + hunk utilities. See `:help gitsigns`
vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '│' },
  },
}

-- Shows pending keybinds
vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

-- [[ Colorscheme ]]
vim.pack.add {
  gh 'morhetz/gruvbox',
  gh 'folke/tokyonight.nvim',
  gh 'rebelot/kanagawa.nvim',
}
vim.opt.termguicolors = true
vim.opt.background = 'dark'

vim.cmd.colorscheme 'tokyonight-night'

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = bg })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = bg })
  end,
})

-- Highlight TODO, NOTE, etc. in comments
vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- Lualine
vim.pack.add { gh 'nvim-lualine/lualine.nvim' }
require('lualine').setup {
  options = {
    theme = 'tokyonight',
    component_separators = '',
    section_separators = { left = '\u{E0B4}', right = '\u{E0B6}' },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      { 'mode', right_padding = 2 },
    },
    lualine_b = {
      { 'branch', icon = '\u{e702}' },
      { 'diff' },
    },
    lualine_c = {
      { 'filename', path = 1 },
      { 'diagnostics' },
    },
    lualine_x = {
      { 'lsp_status' },
    },
    lualine_y = {
      {
        function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end,
      },
    },
    lualine_z = {
      {
        function() return os.date '%Y-%m-%d %I:%M %p' end,
        left_padding = 2,
      },
    },
  },
}

-- Cellular Automaton
vim.pack.add { gh 'eandrju/cellular-automaton.nvim' }
vim.keymap.set('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>')

