---------------------------------------------------------------------------------
--  _   _             _    _____ _ ____ ____  
-- | \ | | ___   __ _| |__|___  / | ___| ___| 
-- |  \| |/ _ \ / _` | '_ \  / /| |___ \___ \ 
-- | |\  | (_) | (_| | | | |/ / | |___) |__) |
-- |_| \_|\___/ \__,_|_| |_/_/  |_|____/____/ 
--
---------------------------------------------------------------------------------
--
-- https://www.youtube.com/channel/UCqGyzqfltwGBneZOUEz7ayg
--
---------------------------------------------------------------------------------
--
-- https://github.com/Noah7155
--
---------------------------------------------------------------------------------

-- PLUGINS --

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

-- languages --
Plug 'stevearc/vim-arduino'
Plug 'ollykel/v-vim'
Plug 'rust-lang/rust.vim'

-- cmp --
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'm4xshen/autoclose.nvim'

-- lsp --
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind.nvim'
Plug 'tami5/lspsaga.nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

-- themes --
Plug 'Noah7155/doom-rouge.nvim'

-- misc. cosmetic --
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'RRethy/vim-hexokinase'

-- misc. utility --
Plug 'scrooloose/nerdtree'
Plug 'mbbill/undotree'
Plug 'nvim-treesitter/nvim-treesitter'

vim.call('plug#end')

-- KEY MAPPING --

local keymap = function(mode, key, action)
    vim.api.nvim_set_keymap(mode, key, action, { noremap = true, silent = true })
end

keymap('n', 'fd', 'zo')
keymap('n', 'ff', 'zfa}')
keymap('n', 'nt', ':NERDTreeToggle<CR>')
keymap('n', 'tt', ':UndotreeToggle<CR>')

-- lsp --
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
keymap('n', 'gn', "<cmd>lua require('lspsaga.rename').rename()<CR>")
keymap('n', 'gr', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>')
keymap('n', 'ga', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')

-- VIM OPTIONS --

vim.o.showmode = false
vim.o.autowriteall = true
vim.wo.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.completeopt = 'menu,menuone'
vim.o.termguicolors = true
nofoldenable = true
foldlevel = 99
vim.cmd[[ 
set tabstop=4 
set shiftwidth=4 
set expandtab 
]]

-- LSP --

require('lspconfig')
require("mason").setup()
require("mason-lspconfig").setup()
local lsp_installer = ("mason-lspconfig")

require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function (server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {}
        end,
}

require('lspsaga').setup({
    error_sign = '',
    warn_sign = '',
    hint_sign = '',
    infor_sign = '',
    diagnostic_header_icon = '█',
    code_action_prompt = {
        enable = false
    }
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		prefix = "━",
		spacing = 0,
	},
	signs = true,
	underline = true,

	-- set this to true if you want diagnostics to show in insert mode
	update_in_insert = false,
})

--require("lspsaga").init_lsp_saga({
--  finder_action_keys = {
--    open = '<CR>',
--    quit = {'q', '<esc>'},
--  },
--  code_action_keys = {
--    quit = {'q', '<esc>'},
--  },
--  rename_action_keys = {
--    quit = '<esc>',
--  },
--})

-- TREESITTER --

require('nvim-treesitter.configs').setup {
	ensure_installed = {"python", "rust", "c", "cpp", "bash", "go", "html"},
	highlight = {
		enable = true,
	}
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {"python", "rust", "c", "cpp", "bash", "go", "html"},
  highlight = {
    enable = true,
  },
}

-- LIGHTLINE --

vim.cmd[[
let g:lightline = { 'colorscheme': 'wombat' }
]]

-- CMP --

require("autoclose").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspkind = require('lspkind')
local cmp = require("cmp")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp_kinds = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<Tab>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },

  formatting = {
    format = lspkind.cmp_format(),
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- COLORSCHEME --

vim.cmd[[
colorscheme doom-rouge
]]

