-- Spaces statt Tab-- Spaces statt Tabs
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "

-- Verhindert auto-continue von Kommentaren in ALLEN Modi
vim.cmd("set formatoptions-=r")  -- Don't auto-continue comments on new line with Enter
vim.cmd("set formatoptions-=o")  -- Don't auto-continue comments with o/O
vim.cmd("set formatoptions-=c")  -- Don't auto-wrap comments
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - "c" - "r" - "o"
  end,
})

-- Line Numbers
vim.o.number = true
--vim.o.relativenumber = true

-- Ctrl+F für Suche aktivieren
vim.keymap.set('n', '<C-f>', '/', { desc = 'Search forward' })
vim.keymap.set('n', '<C-F>', '?', { desc = 'Search backward' })

-- ESC um Suche zu beenden und Highlighting zu entfernen
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true, desc = 'Clear search highlighting' })

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
vim.diagnostic.enable(false)
local diagnostics_active = false
local function toggle_diagnostics()
    if diagnostics_active then
        vim.diagnostic.enable(false)
        print("Diagnostics ausgeschaltet")
    else
        vim.diagnostic.enable()
        print("Diagnostics eingeschaltet")
    end
    diagnostics_active = not diagnostics_active
end

-- Plugins setup
local plugins = {
-- theme
--[[   -- Tokyonight deaktiviert
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd[[colorscheme tokyonight]]
  --end,
--},
--]]

    -- Gruvbox mit leicht dunklerem Background
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        palette_overrides = {
          -- Nur leicht dunkler als standard
          dark0_hard = "#1a1a1a",
          dark0 = "#1a1a1a",
        },
        overrides = {
          Normal = {bg = "#1a1a1a"},
          SignColumn = {bg = "#1a1a1a"},
        },
      })
      vim.cmd.colorscheme("gruvbox")
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
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", 
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"lua", "c", "cpp", "asm", "python", "glsl", "rust", "zig"},
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },
  -- Lualine mit angepasstem dunklerem Theme
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup({
        options = {
          theme = {
            normal = {
              a = { fg = '#ebdbb2', bg = '#689d6a', gui = 'bold' },
              b = { fg = '#ebdbb2', bg = '#3c3836' },
              c = { fg = '#a89984', bg = '#1a1a1a' },
            },
            insert = {
              a = { fg = '#282828', bg = '#83a598', gui = 'bold' },
              b = { fg = '#ebdbb2', bg = '#3c3836' },
              c = { fg = '#a89984', bg = '#1a1a1a' },
            },
            visual = {
              a = { fg = '#282828', bg = '#fe8019', gui = 'bold' },
              b = { fg = '#ebdbb2', bg = '#3c3836' },
              c = { fg = '#a89984', bg = '#1a1a1a' },
            },
            command = {
              a = { fg = '#282828', bg = '#8ec07c', gui = 'bold' },
              b = { fg = '#ebdbb2', bg = '#3c3836' },
              c = { fg = '#a89984', bg = '#1a1a1a' },
            },
            inactive = {
              a = { fg = '#a89984', bg = '#1a1a1a' },
              b = { fg = '#a89984', bg = '#1a1a1a' },
              c = { fg = '#a89984', bg = '#1a1a1a' },
            },
          }
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
          "harper_ls", -- Harper
          "rust_analyzer",
          "zls"        -- Zig
        }
      })
    end
  },
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/lsp_signature.nvim" -- Inline Parameter Hilfe
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")
      
      -- Setup LSPs
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = { "clangd", "--background-index", "--all-scopes-completion" },
      })
      lspconfig.glslls.setup({
        capabilities = capabilities
      })
      lspconfig.harper_ls.setup({
        capabilities = capabilities
      })
      lspconfig.zls.setup({
        capabilities = capabilities,
        cmd = { "zls" },
      })
      
      -- LSP Keybindings mit neuen Fenstern
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover info' })
      -- Go to definition öffnet sich in neuem Split
      vim.keymap.set('n', 'gd', function()
        vim.cmd('split')
        vim.lsp.buf.definition()
      end, { desc = 'Go to definition in new split' })
      -- Alternative: Go to definition in vertikalem Split
      vim.keymap.set('n', 'gD', function()
        vim.cmd('vsplit')
        vim.lsp.buf.definition()
      end, { desc = 'Go to definition in new vertical split' })
      -- Go to implementation in neuem Split
      vim.keymap.set('n', 'gi', function()
        vim.cmd('split')
        vim.lsp.buf.implementation()
      end, { desc = 'Go to implementation in new split' })
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
      vim.keymap.set('n', '<leader>td', toggle_diagnostics, { desc = 'Toggle diagnostics' })
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Show signature help' })

      -- Setup lsp_signature
      require("lsp_signature").setup({
        bind = true,
        floating_window = true,
        hint_enable = true,
        hint_prefix = "🐍 ",
      })
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

  {
    'numToStr/Comment.nvim',
    opts = {
        vim.keymap.set("v", "<gc>", function() require('Comment.api').toggle.linewise.current() end, { noremap = true, silent = true })
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
        experimental = {
          ghost_text = false, -- Kein Ghost Text
        }
      })
    end
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


