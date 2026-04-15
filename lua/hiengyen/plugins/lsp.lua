local M = {}

local servers = {
  ansiblels = {},
  bashls = {},
  clangd = {},
  gopls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
  nil_ls = {},
  pyright = {},
  ruff = {},
  rust_analyzer = {},
  terraformls = {},
  yamlls = {},
}

local function setup_lazydev()
  require('lazydev').setup {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }
end

local function setup_blink()
  require('blink.cmp').setup {
    keymap = {
      preset = 'super-tab',
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
  }
end

local function setup_conform()
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end

      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end,
    formatters_by_ft = {
      bash = { 'shfmt' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      go = { 'goimports', 'gofmt' },
      hcl = { 'terraform_fmt' },
      lua = { 'stylua' },
      nix = { 'nixfmt' },
      python = { 'ruff_fix', 'ruff_format' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      terraform = { 'terraform_fmt' },
      yaml = { 'yamlfmt' },
    },
  }

  vim.keymap.set('n', '<leader>f', function()
    require('conform').format { async = true, lsp_format = 'fallback' }
  end, { desc = '[F]ormat buffer' })
end

local function setup_lint()
  local lint = require 'lint'
  local warned_missing = {}

  local function resolve_linter(name)
    local linter = lint.linters[name]
    if type(linter) == 'function' then
      local ok, resolved = pcall(linter)
      linter = ok and resolved or nil
    end
    return linter
  end

  local function linter_cmd(name)
    local linter = resolve_linter(name)
    if not linter then
      return nil
    end

    local cmd = linter.cmd
    if type(cmd) == 'function' then
      local ok, resolved = pcall(cmd)
      cmd = ok and resolved or nil
    end

    return type(cmd) == 'string' and cmd ~= '' and cmd or nil
  end

  local function linter_is_available(name)
    local cmd = linter_cmd(name)
    if not cmd then
      return false
    end

    return vim.fn.executable(cmd) == 1
  end

  lint.linters_by_ft = {
    json = { 'jsonlint' },
    markdown = { 'markdownlint' },
    terraform = { 'tflint' },
  }

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('hiengyen-lint', { clear = true }),
    callback = function()
      if not vim.bo.modifiable then
        return
      end

      local names = lint.linters_by_ft[vim.bo.filetype] or {}
      local available = {}

      for _, name in ipairs(names) do
        if linter_is_available(name) then
          available[#available + 1] = name
        elseif not warned_missing[name] then
          warned_missing[name] = true
          vim.schedule(function()
            vim.notify(('Skipping linter `%s`: executable not found'):format(name), vim.log.levels.WARN)
          end)
        end
      end

      if #available == 0 then
        return
      end

      lint.try_lint(available, { ignore_errors = true })
    end,
  })
end

local function client_supports_method(client, method, bufnr)
  if vim.fn.has 'nvim-0.11' == 1 then
    return client:supports_method(method, bufnr)
  end

  return client.supports_method(method, { bufnr = bufnr })
end

local function setup_lsp()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('hiengyen-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
      map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
      map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
      map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('hiengyen-lsp-highlight', { clear = false })

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
          group = vim.api.nvim_create_augroup('hiengyen-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'hiengyen-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        return diagnostic.message
      end,
    },
  }

  local capabilities = require('blink.cmp').get_lsp_capabilities()
  local ensure_installed = vim.tbl_keys(servers)
  vim.list_extend(ensure_installed, {
    'shfmt',
    'stylua',
    'tflint',
    'yamlfmt',
  })

  ensure_installed = vim.tbl_filter(function(name)
    return name ~= 'nil_ls'
  end, ensure_installed)

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    ensure_installed = {},
    automatic_installation = false,
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end

function M.setup()
  setup_lazydev()
  require('mason').setup {}
  require('fidget').setup {}
  setup_blink()
  setup_conform()
  setup_lint()
  setup_lsp()
end

return M
