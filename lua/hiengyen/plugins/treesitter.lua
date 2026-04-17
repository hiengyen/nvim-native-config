local M = {}

function M.setup()
  local ok, configs = pcall(require, 'nvim-treesitter.configs')
  if not ok then
    return
  end

  configs.setup {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'go',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'nix',
      'query',
      'python',
      'rust',
      'terraform',
      'vim',
      'vimdoc',
      'yaml',
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
  }
end

return M
