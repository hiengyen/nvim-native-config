-- Init
if vim.loader then
  vim.loader.enable()
end

-- Plugins
require('hiengyen.pack').setup()
require('hiengyen.plugins.appearance').setup()
require('hiengyen.plugins.editor').setup()
require('hiengyen.plugins.search').setup()
require('hiengyen.plugins.lsp').setup()
require('hiengyen.plugins.debug').setup()
require('hiengyen.plugins.treesitter').setup()

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('hiengyen-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

--
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
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
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.modeline = true
vim.o.modelines = 5
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Keymaps
local keymap = vim.keymap.set
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })
keymap('n', '<C-LeftMouse>', '<LeftMouse>gx', { desc = 'Open link under cursor' })
keymap('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
keymap('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = 'Split Window Vertically' })
keymap('n', '<leader>ws', '<cmd>split<cr>', { desc = 'Split Window horizontally' })
keymap('n', '<leader>wq', '<cmd>q<cr>', { desc = 'Window Quit' })
keymap('n', '<leader>qq', '<cmd>q<cr>', { desc = 'Quit current window' })
keymap('n', 'ps', '<cmd>PackStatus<cr>', { desc = 'Open native package status' })
keymap('n', 'pu', '<cmd>PackUpdate<cr>', { desc = 'Update native packages' })
keymap('n', 'pc', '<cmd>PackClean<cr>', { desc = 'Clean inactive native packages' })
keymap('n', '<leader>m', '<cmd>Mason<cr>', { desc = 'Open Mason UI' })
keymap('n', '<leader>h', '<cmd>checkhealth<cr>', { desc = 'Open Healthcheck' })
keymap('n', '<leader>tn', ':tabnew<CR>', { desc = 'Open new tab' })
keymap('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close current tab' })
keymap('n', '<leader>to', ':tabonly<CR>', { desc = 'Close all other tabs' })
keymap('n', '<leader>tm', ':tabmove<CR>', { desc = 'Move current tab' })
keymap('n', '<leader>tl', ':tabnext<CR>', { desc = 'Move to next tab' })
keymap('n', '<leader>th', ':tabprevious<CR>', { desc = 'Move to previous tab' })
keymap('n', '<leader>te', ':tabedit<CR>', { desc = 'Open file in new tab' })
