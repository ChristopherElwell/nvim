-- ============================================================
-- LSP
-- LSP keymaps, server configuration, Mason tool installation
-- See `:help lsp-vs-treesitter` if you're curious about the split
-- ============================================================

local gh = require('config.pack').gh

-- Status updates for LSP
vim.pack.add { gh 'j-hui/fidget.nvim' }
require('fidget').setup {
progress = {
    suppress_on_insert = false,
    ignore = { "texlab", "ltex", 'ltex_plus'}, -- LSP servers to ignore
  },
}

-- Runs whenever an LSP attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Highlight references of the word under the cursor while it rests there,
    -- and clear the highlight again once the cursor moves.
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Toggle inlay hints if the server supports them (can be distracting, hence a toggle)
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
    end

    -- Snacks keymaps
    local picker = Snacks.picker
    local buf = event.buf
    vim.keymap.set('n', 'grr', function() picker.lsp_references() end, { buffer = buf, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gri', function() picker.lsp_implementations() end, { buffer = buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'grd', function() picker.lsp_definitions() end, { buffer = buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gO', function() picker.lsp_symbols() end, { buffer = buf, desc = 'Open Document Symbols' })
    vim.keymap.set('n', 'gW', function() picker.lsp_workspace_symbols() end, { buffer = buf, desc = 'Open Workspace Symbols' })
    vim.keymap.set('n', 'grt', function() picker.lsp_type_definitions() end, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    vim.keymap.set('n', 'grD', function()
      picker.lsp_definitions({ confirm = { action = 'jump', cmd = 'vsplit' } })
    end, { buffer = buf, desc = '[G]oto [D]efinition (split)' })

    vim.keymap.set('n', 'grI', function()
      picker.lsp_implementations({ confirm = { action = 'jump', cmd = 'vsplit' } })
    end, { buffer = buf, desc = '[G]oto [I]mplementation (split)' })

    vim.keymap.set('n', 'grT', function()
      picker.lsp_type_definitions({ confirm = { action = 'jump', cmd = 'vsplit' } })
    end, { buffer = buf, desc = '[G]oto [T]ype Definition (split)' })

    --Breadcrumbs
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local navic = require('nvim-navic')
    if client and client.server_capabilities.documentSymbolProvider then
      navic.attach(client, buf)
    end
  end,
})

-- Language servers to install/enable. See `:help lsp-config`
---@type table<string, vim.lsp.Config>
local servers = {
  html = {},
  cssls = {},
  ts_ls = {},
  clangd = {},

  -- LaTeX: compilation, diagnostics, completion, forward search
  texlab = {
    settings = {
      texlab = {
        build = {
          -- Mirrors the build/ split: aux/log/fls junk -> build/, PDF stays put.
          executable = 'latexmk',
          args = {
            '-pdf',
            '-interaction=nonstopmode',
            '-synctex=1',
            '-aux-directory=build',
            '-outdir=out',
            '%f',
          },
          onSave = true,
          forwardSearchAfter = true,
        },
        forwardSearch = {
          -- SumatraPDF auto-reloads and doesn't lock the file, unlike Chrome/Adobe.
          executable = 'SumatraPDF',
          args = { '-reuse-instance', '-forward-search', '%f', '%l', '%p' },
        },
        chktex = { onOpenAndSave = true },
        diagnosticsDelay = 300,
        latexFormatter = 'latexindent',
        bibtexFormatter = 'texlab',
      },
    },
  },

  -- Grammar/spelling for prose (cover letters). Mason package is
  -- "ltex-ls" but the lspconfig/server name is "ltex" -- mason-tool-
  -- installer translates this automatically via mason-lspconfig's
  -- mapping table, so leave the key as "ltex" here.
  ltex = {
    filetypes = { 'tex', 'plaintex', 'bib', 'markdown' },
    settings = {
      ltex = {
        checkFrequency = 'save',
        language = 'en-US',
        dictionary = {
          ['en-US'] = { 'texlab', 'latexmk', 'nvim', 'SumatraPDF' },
        },
        additionalRules = { enablePickyRules = true },
      },
    },
  },

  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- formatting is done by stylua

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
      client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and can cause issues when working on your own config
          -- see https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- formatting is done by stylua
      },
    },
  },
}

vim.pack.add {
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

require('mason').setup {}

-- Translates between nvim-lspconfig server names and mason.nvim package names
require('mason-lspconfig').setup {
  automatic_enable = false,
}

-- Ensure the servers/tools above are installed. Run `:Mason` to inspect/manage manually.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
