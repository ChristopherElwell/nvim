-- ============================================================
-- Formatting (conform.nvim)
-- ============================================================

local gh = require('config.pack').gh

vim.pack.add { gh 'stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local enabled_filetypes = {
      html = true,
      css = true,
      javascript = true,
      -- python = true,
    }
    if enabled_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- use external formatters if configured below, otherwise LSP formatting
  },
  formatters_by_ft = {
    python = { 'black' },
    html = { 'prettier' },
    css = { 'prettier' },
    javascript = { 'prettier' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
