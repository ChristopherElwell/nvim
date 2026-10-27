-- ============================================================
-- UI / core UX plugins
-- guess-indent, which-key, colorscheme, todo-comments, mini modules, lualine
-- ============================================================

local gh = require('config.pack').gh

-- Automatically detect and set indentation
vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

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
  gh 'rose-pine/neovim'
}
vim.opt.termguicolors = true
vim.opt.background = 'dark'

require('rose-pine').setup {
  styles = {
    transparency = true,
  },
}
vim.cmd.colorscheme 'rose-pine'

-- Breadcrumbs
vim.pack.add({ "https://github.com/SmiteshP/nvim-navic" })

local navic = require('nvim-navic')
navic.setup({
  highlight = true, -- lets navic use its own NavicText/NavicSeparator hl groups
})

-- Lualine
vim.pack.add { gh 'nvim-lualine/lualine.nvim' }
require('lualine').setup {
  options = {
    theme = 'auto',
    component_separators = '',
    section_separators = { left = '\u{E0B4}', right = '\u{E0B6}' },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      { 'mode', fmt = function(str) return str:sub(1, 1) end, right_padding = 2 },
    },
    lualine_b = {
      { 'branch', icon = '\u{e702}' },
      { 'diff' },
      { 'diagnostics' },
    },
    lualine_c = {
      {
        'filename',
        path = 1,
        cond = function()
          return vim.bo.buftype ~= 'terminal'
        end,
      },
      {
        'navic',
        color_correction = 'static', -- fixes icon colors against non-default backgrounds
      },
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
vim.keymap.set('n', '<leader>ca', '<cmd>CellularAutomaton make_it_rain<CR>')

-- Rainbow Brackets 
vim.pack.add { gh 'HiPhish/rainbow-delimiters.nvim' }

-- Coloured line number
vim.pack.add { gh 'mawkler/modicator.nvim'}
require("modicator").setup({})

-- Better search info
vim.pack.add {gh 'kevinhwang91/nvim-hlslens'}
require("hlslens").setup()
local kopts = {noremap = true, silent = true}
vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)

-- Color column
local colorcolumn_enabled = false

local function toggle_colorcolumn()
  colorcolumn_enabled = not colorcolumn_enabled
  local value = colorcolumn_enabled and '80' or ''

  vim.o.colorcolumn = value -- default for windows opened from now on

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_set_option_value('colorcolumn', value, { win = win })
  end
end

vim.keymap.set('n', '<leader>tr', toggle_colorcolumn, { desc = '[T]oggle 80-char [R]uler (global)' })
