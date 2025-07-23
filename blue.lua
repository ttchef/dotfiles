--Tabs size usw-- Basic Setting-- Basic Settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "

-- Disable auto-formatting features that might cause duplication
vim.cmd("set formatoptions-=r")  -- Don't auto-continue comments on new line
vim.cmd("set formatoptions-=o")  -- Don't auto-continue comments with o/O

-- Line Numbers
vim.o.number = true
--vim.o.relativenumber = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "Press any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Toggle-Funktion für Diagnostics
vim.diagnostic.disable()
local diagnostics_active = false
local function toggle_diagnostics()
    if diagnostics_active then
        vim.diagnostic.disable()
        print("Diagnostics ausgeschaltet")
    else
        vim.diagnostic.enable()
        print("Diagnostics eingeschaltet")
    end
    diagnostics_active = not diagnostics_active
end

-- Plugins setup
local plugins = {
  -- Farbschema
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end,
  },
  -- Telescope
  {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fg', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fc', builtin.live_grep, { desc = 'Telescope live grep' })
    end,
  },
    --[[Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", 
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"lua", "c", "cpp", "asm", "python", "disassembly", "glsl", "rust"},
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
    --]]--Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },
  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup({
        options = {
          theme = 'dracula'
        }
      })
    end
  },
  -- Icons
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
  },
  -- Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  -- Mason-LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { 
          "lua_ls",    -- Lua
          "clangd",    -- C/C++
          "glslls",    -- GLSL
          "harper_ls",  -- Harper
          "rust_analyzer",
          "zls" -- Zig
        }
      })
    end
  },
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
      lspconfig.glslls.setup({
        capabilities = capabilities
      })
      lspconfig.harper_ls.setup({
        capabilities = capabilities
      })
      lspconfig.zls.setup({
      	capabilities = capabilities
      })
      
      -- LSP Keybindings
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
      vim.keymap.set('n', '<leader>td', toggle_diagnostics, { desc = 'Toggle diagnostics' })
    end
  },
  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets'
    }
  },
  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      
     cmp.setup({
        snippet = {
            expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' }
    }),

    formatting = {
        format = function(entry, vim_item)
        local kind = vim.lsp.protocol.CompletionItemKind[vim_item.kind] or vim_item.kind
        vim_item.kind = string.format('%s %s', require('nvim-web-devicons').get_icon_by_filetype(kind, { default = true }) or '', kind)
        return vim_item
    end,
  },
  experimental = {
    ghost_text = false, -- kein GhostText
  },
})    end
  },
  -- Usage tracking
  {
    "Aityz/usage.nvim",
    config = function()
      require('usage').setup()
    end
  },

}

-- Initialize lazy.nvim
require("lazy").setup(plugins)

return
