local M = {}

local function setup_gitsigns()
  require('gitsigns').setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
          return
        end

        gitsigns.nav_hunk 'next'
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
          return
        end

        gitsigns.nav_hunk 'prev'
      end, { desc = 'Jump to previous git [c]hange' })

      map('v', '<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'git [s]tage hunk' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'git [r]eset hunk' })

      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
      map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
      map('n', '<leader>hD', function()
        gitsigns.diffthis '@'
      end, { desc = 'git [D]iff against last commit' })
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
    end,
  }
end

local function setup_which_key()
  local wk = require 'which-key'

  wk.setup {
    delay = 0,
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },
  }

  wk.add {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>w', group = '[W]indow' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  }
end

local function setup_mini()
  require('mini.ai').setup { n_lines = 500 }
  require('mini.surround').setup()

  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }

  statusline.section_location = function()
    return '%2l:%-2v'
  end
end

local function setup_treesitter()
  require('nvim-treesitter.configs').setup {
    ensure_installed = require('hiengyen.pack').treesitter_parsers,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  }
end

local function setup_oscyank()
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('hiengyen-oscyank', { clear = true }),
    callback = function()
      if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
        vim.cmd 'OSCYankRegister "'
      end
    end,
  })
end

local function setup_codeium()
  vim.keymap.set('i', '<M-a>', function()
    return vim.fn['codeium#Accept']()
  end, { expr = true, silent = true, desc = 'Accept Codeium suggestion' })

  vim.keymap.set('i', '<M-]>', function()
    return vim.fn['codeium#CycleCompletions'](1)
  end, { expr = true, silent = true, desc = 'Next Codeium suggestion' })

  vim.keymap.set('i', '<M-[>', function()
    return vim.fn['codeium#CycleCompletions'](-1)
  end, { expr = true, silent = true, desc = 'Previous Codeium suggestion' })

  vim.keymap.set('i', '<M-x>', function()
    return vim.fn['codeium#Clear']()
  end, { expr = true, silent = true, desc = 'Clear Codeium suggestion' })
end

function M.setup()
  setup_gitsigns()
  setup_which_key()
  require('todo-comments').setup { signs = false }
  require('nvim-autopairs').setup {}
  require('ibl').setup {}
  require('neo-tree').setup {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  }
  vim.keymap.set('n', '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

  setup_mini()
  setup_treesitter()
  setup_oscyank()
  setup_codeium()
end

return M
