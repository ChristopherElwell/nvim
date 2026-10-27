-- ============================================================
-- Core options
-- See `:help vim.o` and `:help option-list`
-- ============================================================

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Leader key must be set before plugins load
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.nofsync = true
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.wrap = false;
vim.opt.conceallevel = 0

function _G.project_name()
  local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
  return vim.fn.fnamemodify(root, ":t")
end

vim.opt.title = true
vim.opt.titlestring = "%{v:lua.project_name()} - nvim"tle = true;

-- Control which files get wrapped
local prose_filetypes = {
  "markdown",
  "text",
  "gitcommit",
  "tex",
  "rst",
  "asciidoc",
  "mail",
  "json"
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = prose_filetypes,
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 80
  vim.opt_local.formatoptions:append("t")
  end,
})

-- Sync clipboard between OS and Neovim, scheduled after UiEnter to avoid
-- slowing down startup. Remove if you want the OS clipboard independent.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

-- Whitespace display. Note: `list` is set via `vim.o`, `listchars` via
-- `vim.opt` since it needs the table interface.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Preview substitutions live, as you type
vim.o.inccommand = 'split'

vim.o.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 10

-- If an operation would fail due to unsaved changes (like `:q`), raise a
-- dialog asking whether to save instead of just failing. See `:help 'confirm'`
vim.o.confirm = true
