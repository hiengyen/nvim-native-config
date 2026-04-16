if vim.loader then
  vim.loader.enable()
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 1000
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

-- Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })
vim.keymap.set('n', '<C-LeftMouse>', '<LeftMouse>gx', { desc = 'Open link under cursor' })
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = 'Split Window Vertically' })
vim.keymap.set('n', '<leader>ws', '<cmd>split<cr>', { desc = 'Split Window horizontally' })
vim.keymap.set('n', '<leader>wq', '<cmd>q<cr>', { desc = 'Window Quit' })
vim.keymap.set('n', '<leader>qq', '<cmd>q<cr>', { desc = 'Quit current window' })
vim.keymap.set('n', 'ps', '<cmd>PackStatus<cr>', { desc = 'Open native package status' })
vim.keymap.set('n', 'pu', '<cmd>PackUpdate<cr>', { desc = 'Update native packages' })
vim.keymap.set('n', 'pc', '<cmd>PackClean<cr>', { desc = 'Clean inactive native packages' })
vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = 'Open Mason UI' })
vim.keymap.set('n', '<leader>h', '<cmd>checkhealth<cr>', { desc = 'Open Healthcheck' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('hiengyen-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

require('hiengyen.pack').setup()
require('hiengyen.plugins.appearance').setup()
require('hiengyen.plugins.editor').setup()
require('hiengyen.plugins.search').setup()
require('hiengyen.plugins.lsp').setup()
require('hiengyen.plugins.debug').setup()

vim.o.modeline = true
vim.o.modelines = 5
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
