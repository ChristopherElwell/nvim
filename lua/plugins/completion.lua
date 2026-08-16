-- ============================================================
-- Autocomplete & snippets (blink.cmp + LuaSnip)
-- ============================================================

local gh = require('config.pack').gh

-- [[ Snippet engine ]]
vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

-- `friendly-snippets` has premade snippets for many languages, currently unused:
-- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
-- require('luasnip.loaders.from_vscode').lazy_load()

-- [[ Autocomplete engine ]]
vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    -- 'super-tab': tab to accept. See `:help blink-cmp-config-keymap` for other presets.
    -- All presets share: <tab>/<s-tab> move through snippet expansion, <c-space> open
    -- menu/docs, <c-n>/<c-p> or <up>/<down> select, <c-e> hide menu, <c-k> toggle signature help.
    preset = 'super-tab',
    -- For advanced LuaSnip keymaps (choice nodes, expansion) see:
    --   https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  snippets = { preset = 'luasnip' },

  -- Lua fuzzy matcher; 'prefer_rust_with_warning' downloads a prebuilt rust binary instead
  fuzzy = { implementation = 'lua' },

  signature = { enabled = true },
}

-- [[ Tabout ]]
vim.pack.add { gh 'abecodes/tabout.nvim' }
require('tabout').setup {
  tabkey = '<A-l>',
  backwards_tabkey = '<A-h>',
  act_as_tab = true,
  act_as_shift_tab = false,
  default_tab = '<C-t>',
  default_shift_tab = '<C-d>',
  enable_backwards = true,
  completion = true, -- use tabout to escape an open completion menu too
  tabouts = {
    { open = "'", close = "'" },
    { open = '"', close = '"' },
    { open = '`', close = '`' },
    { open = '(', close = ')' },
    { open = '[', close = ']' },
    { open = '{', close = '}' },
  },
  ignore_beginning = true,
  exclude = {},
}
