-- ============================================================
-- init.lua - entry point
-- Loads core config first, then plugin manager helpers, then
-- each plugin group. Order matters: options/keymaps before
-- anything else, and config.pack (which defines `gh()`) before
-- any plugins.* module that calls it.
-- ============================================================

require 'config.options'
require 'config.keymaps'
require 'config.pack'

require 'plugins.ui'
require 'plugins.snacks'
require 'plugins.lsp'
require 'plugins.format'
require 'plugins.completion'
require 'plugins.treesitter'
require 'plugins.git'
require 'plugins.web'
require 'plugins.editor'
