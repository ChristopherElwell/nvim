-- ============================================================
-- Web
-- ============================================================

local gh = require('config.pack').gh

vim.pack.add {
  gh 'mattn/emmet-vim',
  gh 'catgoose/nvim-colorizer.lua',
  gh 'windwp/nvim-ts-autotag',
}

require('colorizer').setup{
  filetypes = {
    "css"
  }
}
require('nvim-ts-autotag').setup()
