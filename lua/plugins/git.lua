-- ============================================================
-- Git
-- ============================================================

local gh = require('config.pack').gh

vim.pack.add { gh 'kdheepak/lazygit.nvim' }
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = '[G]it ([G]ui via lazygit)' })

-- Git signs in the gutter + hunk utilities. See `:help gitsigns`
vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {

on_attach = function(bufnr)
  local gs = require('gitsigns')
  local function map(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
  end

  -- Navigation - jumps to next/prev hunk, wraps with count, works with quickfix too
  map('n', ']h', function() gs.nav_hunk('next', { target = 'all'}) end, 'Next hunk')
  map('n', '[h', function() gs.nav_hunk('prev', { target = 'all'}) end, 'Prev hunk')

  -- Actions
  map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
  map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
  map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Stage hunk')
  map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Reset hunk')
  map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
  map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
  map('n', '<leader>hp', gs.preview_hunk_inline, 'Preview hunk')

  -- Text object - "ih" selects the current hunk, e.g. dih to delete it
  map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select hunk')
end,
}

vim.pack.add{gh 'sindrets/diffview.nvim'}
vim.keymap.set("n", "<leader>hd", "<Cmd>DiffviewOpen<CR>", {
    desc = "Open Diffview",
})

vim.keymap.set("n", "<leader>hh", "<Cmd>DiffviewFileHistory<CR>", {
    desc = "Git file history",
})

vim.keymap.set("n", "q", "<Cmd>DiffviewClose<CR>", {
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
