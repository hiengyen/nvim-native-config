local M = {}

function M.setup()
  require('dracula').setup {
    italic_comment = false,
  }

  vim.cmd.colorscheme 'dracula'
end

return M
