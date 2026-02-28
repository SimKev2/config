local home = os.getenv('HOME')
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
vim.cmd 'let mapleader = " "'
vim.g.python3_host_prog = home .. "/envs/py3neovim/bin/python"

-- TODO figure out how to set this conditionally in lua https://github.com/chriskempson/base16-shell
-- New computer comment out the next two lines until you run a PaqInstall
vim.g.base16colorspace = 256
vim.cmd("colorscheme base16-default-dark")

require "paq" {
    -- Let Paq manage itself
    "savq/paq-nvim";

    -- GUI colors
    "chriskempson/base16-vim";

    -- File tree explorer
    -- "scrooloose/nerdtree";
    "kyazdani42/nvim-web-devicons"; -- Requires patched font
    "kyazdani42/nvim-tree.lua";

    -- Common configs for builtin language client
    "neovim/nvim-lspconfig";

    -- Code Completion
    "hrsh7th/cmp-nvim-lsp";
    "hrsh7th/cmp-buffer";
    "hrsh7th/cmp-path";
    "hrsh7th/cmp-cmdline";
    "hrsh7th/nvim-cmp";
    -- Snippet engine
    "hrsh7th/vim-vsnip";
    "hrsh7th/vim-vsnip-integ";

    -- Syntax highlighting / parsing
    "windwp/nvim-autopairs";
    "nvim-treesitter/nvim-treesitter";

    -- Fuzzy File Search
    {"junegunn/fzf", build = vim.fn['fzf#install']};
    "junegunn/fzf.vim";

    -- Fuzzy Text Search
    "mileszs/ack.vim";

    -- Enable builtin LSP to use FZF
    "ojroques/nvim-lspfuzzy";

    -- Language packs for syntax/indentation/highlighting
    -- Old usage, :TSInstall should replace
    -- "sheerun/vim-polyglot";

    -- PlantUML preview
    "tyru/open-browser.vim";
    "weirongxu/plantuml-previewer.vim";
    "aklt/plantuml-syntax";
}


local cmp = require'cmp'
cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
}


-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require'nvim-autopairs'.setup({
    check_ts = true,
    enable_check_bracket_line = false,
    ts_config = {
        lua = {'string'},
        javascript = {'template_string'},
        java = false,
    }
})
require'nvim-treesitter.configs'.setup {
    autotag = {
      enable = true,
    },
    ensure_installed = { "lua", "rust", "python", "go", "jsonnet", "bash" },
    highlight = { enable = true, disable = { "python" } },
    autopairs = { enable = true },
    indent = { enable = true, disable = { "python", "yaml" }}
}

require'nvim-tree'.setup{
    view = {
        width = 40,
    },
    renderer = {
        add_trailing = true, -- Add trailing slash to folders
        icons = {
            show = {git = false, folder = true, file = true, folder_arrow = true},
        },
        indent_markers = {
            enable = true,
        },
    },
    filters = {
        custom = { '.pyc', '__pycache__', '.egg-info', 'node_modules' },
    },
    git = {
        enable = false,
        ignore = false,
        timeout = 400,
    },
}
require'nvim-web-devicons'.setup{
    default = true;
}

-- ################################################################################################
-- # LSP Client Config
-- ################################################################################################
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Disable log, set to "debug" if needed
vim.lsp.set_log_level("off")

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach_common = function(client, bufnr)
    -- print("LSP started.");
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    local bufopts = { noremap=true, silent=true, buffer=0 }

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gu', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)

    if client.server_capabilities.documentFormattingProvider then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({async=false})]]
        vim.cmd [[augroup END]]
    end
end
local eslint_d = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
    formatStdin = true
}
vim.lsp.config('pylsp', {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        on_attach_common(client, bufnr)
    end,
    capabilities = capabilities
})
vim.lsp.config('rust_analyzer', {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        on_attach_common(client, bufnr)
    end,
    capabilities = capabilities
})
vim.lsp.config('ts_ls', {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        on_attach_common(client, bufnr)
    end,
    capabilities = capabilities
})
vim.lsp.config('efm', {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        on_attach_common(client, bufnr)
    end,
    capabilities = capabilities,
    init_options = {documentFormatting = true},
    filetypes = {"javascript","typescript","typescriptreact","javascriptreact","javascript.jsx","typescript.tsx"},
    settings = {
        languages = {
            javascript = {eslint_d},
            typescript = {eslint_d},
            javascriptreact = {eslint_d},
            typescriptreact = {eslint_d},
        }
    }
})
vim.lsp.config('gopls', {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        on_attach_common(client, bufnr)
    end,
    capabilities = capabilities
})
vim.lsp.config('jsonnet_ls', {
    settings = {
        show_docstring_in_completion = false,
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        on_attach_common(client, bufnr)
    end,
    capabilities = capabilities
})

vim.lsp.enable({'pylsp', 'rust_analyzer', 'ts_ls', 'efm', 'gopls', 'jsonnet_ls'})

-- Make the LSP client use FZF instead of quickfix list
require'lspfuzzy'.setup{}


-- require'open-browser'.setup{}
-- require'plantuml-syntax'.setup{}
-- require'plantuml-previewer'.setup{}

-- <Tab> to navigate the completion menu
-- map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
-- map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})

-- ################################################################################################
-- # General Vim options
-- ################################################################################################
-- vim.cmd 'syntax on'
vim.opt.background = "dark"
vim.cmd 'hi Normal ctermbg=NONE'
-- vim.cmd 'filetype plugin indent on'

-- Remove auto wrap while typing
vim.opt.formatoptions:remove("t")

map('n', '<Leader>w', ':w<CR>')
map('n', '<Leader>w<CR>', ':w<CR>')
map('n', '<Leader>wq', ':wq<CR>')
map('n', '<Leader>wq<CR>', ':wq<CR>')
map('n', '<Leader>q', ':q<CR>')
map('n', '<Leader>q<CR>', ':q<CR>')
map('n', '<Leader>f', ':FZF<CR>')


vim.g['ackprg'] = 'rg --vimgrep --no-heading'
vim.g['fzf_buffers_jump'] = 1

vim.opt.mouse = ""

vim.opt.colorcolumn = "100"              -- Column limit
vim.opt.completeopt = "menuone,noselect" -- Completion options
vim.opt.hidden = true                    -- Enable background buffers

vim.opt.wrap = false                     -- Do not visually wrap single lines
vim.opt.joinspaces = false               -- No double spaces with join
vim.opt.termguicolors = true             -- True color support
vim.opt.signcolumn = "yes"               -- Always show sign column

vim.opt.splitright = true                -- Put new windows right of current
vim.opt.splitbelow = true                -- Put new windows below current

vim.opt.tabstop = 4                      -- Number of spaces tabs count for
vim.opt.shiftwidth = 4                   -- Size of an indent
vim.opt.softtabstop = 4                  -- Number of spaces tabs count for
vim.opt.expandtab = true                 -- Use spaces instead of tabs
vim.opt.scroll = 20                      -- Number of lines jumbed with CTRL+U/D
vim.opt.scrolloff = 4                    -- Lines of context around cursor line
vim.opt.sidescrolloff = 8                -- Columns of context

vim.opt.incsearch = true                 -- Show matches as you type search
vim.opt.ignorecase = true                -- Ignore case
vim.opt.smartcase = true                 -- Do not ignore case with capitals
vim.opt.gdefault = true                  -- Default replace globally

vim.opt.number = true                    -- Show line numbers

vim.opt.list = true                      -- Show some invisible characters
vim.opt.wildmode = {'list', 'longest'}   -- Command-line completion mode

map('', '<C-c>', '"+y')                 -- Copy to clipboard in normal, visual, select and operator modes
map('', '<C-n>', ':NvimTreeToggle<CR>') -- Open file explorer
map('', '<C-p>', ':Ack!<Space>')        -- Run fuzzy text finder in project

map('n', '<C-f>', ':FZF<CR>')           -- Open fuzzy file search
map('n', '<C-H>', '<C-W><C-H>')         -- Quick pane movements
map('n', '<C-J>', '<C-W><C-J>')
map('n', '<C-K>', '<C-W><C-K>')
map('n', '<C-L>', '<C-W><C-L>')
map('n', '<C-g>', ':NvimTreeFindFile<CR>')
map('n', 'th', ':tabfirst<CR>')         -- Quick tab movements
map('n', 'tj', ':tabnext<CR>')
map('n', 'tk', ':tabprev<CR>')
map('n', 'tl', ':tablast<CR>')
map('n', 'tt', ':tabedit<Space>')
map('n', 'tn', ':tabnext<Space>')
map('n', 'tm', ':tabm<Space>')
map('n', 'td', ':tabclose<CR>')
