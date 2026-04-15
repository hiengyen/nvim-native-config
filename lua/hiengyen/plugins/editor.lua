local M = {}

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
  local pack = require 'hiengyen.pack'
  require('nvim-treesitter').setup {
    install_dir = pack.treesitter_install_dir,
  }

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('hiengyen-treesitter', { clear = true }),
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft
      local parser = vim.api.nvim_get_runtime_file(('parser/%s.*'):format(lang), true)

      if #parser == 0 then
        return
      end

      pcall(vim.treesitter.start, args.buf, lang)
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldmethod = 'expr'

      if lang ~= 'ruby' then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
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
  setup_which_key()
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
