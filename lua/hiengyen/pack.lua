local M = {}

local commits = {
  ['LuaSnip'] = '642b0c595e11608b4c18219e93b88d7637af27bc',
  ['blink.cmp'] = '78336bc89ee5365633bcf754d93df01678b5c08f',
  ['codeium.vim'] = '3c0a4f8a7be75113a6e19be13b7cc37210d6e26a',
  ['conform.nvim'] = '086a40dc7ed8242c03be9f47fbcee68699cc2395',
  ['dracula.nvim'] = 'ae752c13e95fb7c5f58da4b5123cb804ea7568ee',
  ['fidget.nvim'] = '889e2e96edef4e144965571d46f7a77bcc4d0ddf',
  ['guess-indent.nvim'] = '84a4987ff36798c2fc1169cbaff67960aed9776f',
  ['indent-blankline.nvim'] = 'd28a3f70721c79e3c5f6693057ae929f3d9c0a03',
  ['mason-lspconfig.nvim'] = '0a3b42c3e503df87aef6d6513e13148381495c3a',
  ['mason-nvim-dap.nvim'] = '9a10e096703966335bd5c46c8c875d5b0690dade',
  ['mason-tool-installer.nvim'] = '443f1ef8b5e6bf47045cb2217b6f748a223cf7dc',
  ['mason.nvim'] = 'b03fb0f20bc1d43daf558cda981a2be22e73ac42',
  ['mini.nvim'] = '27a3e747a4e603b4121f5759e74020430ec7b7d5',
  ['neo-tree.nvim'] = '84c75e7a7e443586f60508d12fc50f90d9aee14e',
  ['nui.nvim'] = 'de740991c12411b663994b2860f1a4fd0937c130',
  ['nvim-autopairs'] = '59bce2eef357189c3305e25bc6dd2d138c1683f5',
  ['nvim-dap'] = '45a69eba683a2c448dd9ecfc4de89511f0646b5f',
  ['nvim-dap-go'] = 'b4421153ead5d726603b02743ea40cf26a51ed5f',
  ['nvim-dap-ui'] = '1a66cabaa4a4da0be107d5eda6d57242f0fe7e49',
  ['nvim-lint'] = 'eab58b48eb11d7745c11c505e0f3057165902461',
  ['nvim-lspconfig'] = 'd10ce09e42bb0ca8600fd610c3bb58676e61208d',
  ['nvim-nio'] = '21f5324bfac14e22ba26553caf69ec76ae8a7662',
  ['nvim-web-devicons'] = 'c72328a5494b4502947a022fe69c0c47e53b6aa6',
  ['plenary.nvim'] = '74b06c6c75e4eeb3108ec01852001636d85a932b',
  ['telescope-fzf-native.nvim'] = '6fea601bd2b694c6f2ae08a6c6fab14930c60e2c',
  ['telescope-ui-select.nvim'] = '6e51d7da30bd139a6950adf2a47fda6df9fa06d2',
  ['telescope.nvim'] = '471eebb1037899fd942cc0f52c012f8773505da1',
  ['vim-oscyank'] = 'd67d76b2f19b868b70a1cf33a779d71dc092cb30',
  ['which-key.nvim'] = '3aab2147e74890957785941f0c1ad87d0a44c15a',
}

local function gh(repo)
  return 'https://github.com/' .. repo
end

local function spec(repo)
  local name = repo:match('[^/]+$')
  return { src = gh(repo), version = commits[name] }
end

local function run(cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if result.code == 0 then
    return
  end

  local err = result.stderr ~= '' and result.stderr or result.stdout
  error(err ~= '' and err or table.concat(cmd, ' '))
end

local function inactive_plugin_names()
  local names = {}
  for _, plugin in ipairs(vim.pack.get()) do
    if not plugin.active then
      names[#names + 1] = plugin.spec.name
    end
  end
  table.sort(names)
  return names
end

local function define_commands()
  vim.api.nvim_create_user_command('PackStatus', function()
    vim.pack.update(nil, { offline = true })
  end, { desc = 'Show native package status' })

  vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
  end, { desc = 'Update native packages' })

  vim.api.nvim_create_user_command('PackClean', function()
    local names = inactive_plugin_names()
    if #names == 0 then
      vim.notify('vim.pack: no inactive plugins to remove', vim.log.levels.INFO)
      return
    end

    vim.pack.del(names)
  end, { desc = 'Delete inactive native packages from disk' })
end

local function on_pack_changed(event)
  local name = event.data.spec.name
  local kind = event.data.kind

  if kind ~= 'install' and kind ~= 'update' then
    return
  end

  if name == 'telescope-fzf-native.nvim' then
    if vim.fn.executable 'make' == 1 then
      run({ 'make' }, event.data.path)
    end
    return
  end

  if name == 'LuaSnip' then
    if vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
      run({ 'make', 'install_jsregexp' }, event.data.path)
    end
    return
  end

end

M.specs = {
  spec 'NMAC427/guess-indent.nvim',
  spec 'folke/which-key.nvim',
  spec 'nvim-lua/plenary.nvim',
  spec 'nvim-telescope/telescope.nvim',
  spec 'nvim-telescope/telescope-fzf-native.nvim',
  spec 'nvim-telescope/telescope-ui-select.nvim',
  spec 'nvim-tree/nvim-web-devicons',
  spec 'neovim/nvim-lspconfig',
  spec 'mason-org/mason.nvim',
  spec 'mason-org/mason-lspconfig.nvim',
  spec 'WhoIsSethDaniel/mason-tool-installer.nvim',
  spec 'j-hui/fidget.nvim',
  spec 'stevearc/conform.nvim',
  spec 'saghen/blink.cmp',
  spec 'L3MON4D3/LuaSnip',
  spec 'Mofiqul/dracula.nvim',
  spec 'echasnovski/mini.nvim',
  spec 'lukas-reineke/indent-blankline.nvim',
  spec 'mfussenegger/nvim-lint',
  spec 'windwp/nvim-autopairs',
  spec 'nvim-neo-tree/neo-tree.nvim',
  spec 'MunifTanjim/nui.nvim',
  spec 'Exafunction/codeium.vim',
  spec 'ojroques/vim-oscyank',
  spec 'mfussenegger/nvim-dap',
  spec 'rcarriga/nvim-dap-ui',
  spec 'jay-babu/mason-nvim-dap.nvim',
  spec 'leoluz/nvim-dap-go',
  spec 'nvim-neotest/nvim-nio',
}

function M.setup()
  vim.g.codeium_disable_bindings = 1

  define_commands()

  vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('hiengyen-pack-hooks', { clear = true }),
    callback = on_pack_changed,
  })

  vim.pack.add(M.specs, { load = true, confirm = true })
end

return M
