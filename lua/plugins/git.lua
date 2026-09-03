-- ============================================================
-- Git
-- ============================================================

local gh = require('config.pack').gh

vim.pack.add { gh 'kdheepak/lazygit.nvim' }
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = '[G]it ([G]ui via lazygit)' })

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
  signs_staged = {
  add          = { text = '▊' },
  change       = { text = '▊' },
  delete       = { text = '▁' },
  topdelete    = { text = '▔' },
  changedelete = { text = '▊' },
},

on_attach = function(bufnr)
  local gs = require('gitsigns')
  local function map(mode, l, r, desc, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.desc = desc
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation - jumps to next/prev hunk, wraps with count, works with quickfix too
  map('n', ']c', function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function() gs.nav_hunk('next') end)
    return '<Ignore>'
  end, 'Next hunk', { expr = true })

  map('n', '[c', function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function() gs.nav_hunk('prev') end)
    return '<Ignore>'
  end, 'Prev hunk', { expr = true })

  -- Actions
  map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
  map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
  map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Stage hunk')
  map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Reset hunk')
  map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
  map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
  map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
  map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Blame line')
  map('n', '<leader>hd', gs.diffthis, 'Diff this')

  -- Text object - "ih" selects the current hunk, e.g. dih to delete it
  map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select hunk')
end,
}

local function set_gitsigns_colors()
  vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#3fb950' })    -- green
  vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#4493f8' }) -- blue
  vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#f85149' }) -- red
  vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { fg = '#f85149' })
  vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { fg = '#4493f8' })

  -- staged hunks - same hues, dimmer, so staged vs unstaged reads at a glance
  vim.api.nvim_set_hl(0, 'GitSignsStagedAdd', { fg = '#2ea043' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { fg = '#316dca' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedDelete', { fg = '#c93c37' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedTopdelete', { fg = '#c93c37' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedChangedelete', { fg = '#316dca' })
end

set_gitsigns_colors()

-- Re-apply after any colorscheme switch, since a new colorscheme will
-- reset these back to whatever it links Diff* to
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = set_gitsigns_colors,
})

vim.pack.add{gh 'sindrets/diffview.nvim'}
local actions = require("diffview.actions")
vim.keymap.set("n", "<leader>gd", "<Cmd>DiffviewOpen<CR>", {
    desc = "Open Diffview",
})

vim.keymap.set("n", "<leader>gh", "<Cmd>DiffviewFileHistory<CR>", {
    desc = "Git file history",
})

vim.keymap.set("n", "<leader>gc", "<Cmd>DiffviewClose<CR>", {
    desc = "Close Diffview",
})
require("diffview").setup({
    enhanced_diff_hl = true,
    use_icons = true,
    show_help_hints = true,
    watch_index = true,

    view = {
        default = {
            layout = "diff2_horizontal",
            disable_diagnostics = false,
            winbar_info = false,
        },

        merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
        },

        file_history = {
            layout = "diff2_horizontal",
            position = "bottom",
            height = 16,
        },
    }
})
