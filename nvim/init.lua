local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

require "paq" {
    -- Let Paq manage itself
    "savq/paq-nvim";

    -- GUI colors
    "chriskempson/base16-vim";

    -- File tree explorer
    -- "scrooloose/nerdtree";
    "kyazdani42/nvim-web-devicons"; -- Requires patched font
    "kyazdani42/nvim-tree.lua";

    -- Code Completion
    "hrsh7th/nvim-compe";
    -- "shougo/deoplete-lsp";
    -- {"shougo/deoplete.nvim", run = vim.fn['remote#host#UpdateRemotePlugins']};
    -- Common configs for builtin language client
    "neovim/nvim-lspconfig";

    -- Syntax highlighting / parsing
    "windwp/nvim-autopairs";
    "nvim-treesitter/nvim-treesitter";

    -- Fuzzy Search
    {"junegunn/fzf", run = vim.fn['fzf#install']};
    "junegunn/fzf.vim";

    -- Enable builtin LSP to use FZF
    "ojroques/nvim-lspfuzzy";

}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

require'nvim-autopairs'.setup({
    check_tx = true,
    enable_check_bracket_line = false,
    ts_config = {
        lua = {'string'},
        javascript = {'template_string'},
        java = false,
    }
})
require'nvim-autopairs.completion.compe'.setup({
    map_cr = true,
    map_complete = true
})
require'nvim-treesitter.configs'.setup{ensure_installed='maintained',highlight={enable=true},autopairs={enable=true},indent={enable=true}}

vim.opt.background = "dark"
vim.cmd 'let mapleader = " "'
vim.cmd 'hi Normal ctermbg=NONE'
vim.cmd 'source ~/.vimrc_background'
--vim.opt.base16colorspace = 256
--vim.so.aqua = '#3AFFDB'

vim.cmd 'filetype plugin indent on'

vim.g['deoplete#enable_at_startup'] = 1
vim.g['ackprg'] = 'rg --vimgrep --no-heading'

-- vim.g['NERDTreeWinSize'] = 40
-- vim.g['NERDTreeIgnore'] = {'\\.pyc$', '__pycache__', '\\.egg-info$'}
-- vim.g['NERDTreeShowHidden'] = 1

vim.g['nvim_tree_width'] = 40
--vim.g['nvim_tree_git_hl'] = 1
vim.g['nvim_tree_ignore'] = { '.pyc', '__pycache__', '.egg-info', 'node_modules' }
vim.g['nvim_tree_add_trailing'] = 1 -- Add trailing slash to folders
vim.g['nvim_tree_show_icons'] = {git = 0, folders = 1, files = 1, folder_arrows = 1}
vim.g['nvim_tree_auto_open'] = 1
vim.g['nvim_tree_tab_open'] = 1
--vim.cmd 'autocmd filetype NvimTree highlight js ctermbg=none ctermfg=blue guifg=#55A8ED guifg=none'
--vim.cmd 'autocmd filetype NvimTree syn match js /^\\s\\+.*js*\\*\\=$/'
--vim.cmd 'autocmd filetype NvimTree syn match js /js/'
--vim.cmd 'hi NvimTreeFolderName guibg=blue'
--vim.g['nvim_tree_icons'] = {default = ''}

vim.g['fzf_buffers_jump'] = 1

vim.opt.colorcolumn = "100"              -- Column limit
vim.opt.completeopt = "menuone,noselect" -- Completion options
vim.opt.hidden = true                    -- Enable background buffers
--vim.opt.shortmess = "filnxtTo0Fc"        -- Avoid hit-enter prompts

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
--map('', '<C-n>', ':NERDTreeToggle<CR>') -- Open file explorer
map('', '<C-n>', ':NvimTreeToggle<CR>') -- Open file explorer
map('', '<C-p>', ':Ack!<Space>')        -- Run fuzzy text finder in project

map('n', '<C-f>', ':FZF<CR>')           -- Open fuzzy file search
map('n', '<C-H>', '<C-W><C-H>')         -- Quick pane movements
map('n', '<C-J>', '<C-W><C-J>')
map('n', '<C-K>', '<C-W><C-K>')
map('n', '<C-L>', '<C-W><C-L>')
map('n', 'th', ':tabfirst<CR>')         -- Quick tab movements
map('n', 'tj', ':tabnext<CR>')
map('n', 'tk', ':tabprev<CR>')
map('n', 'tl', ':tablast<CR>')
map('n', 'tt', ':tabedit<Space>')
map('n', 'tn', ':tabnext<Space>')
map('n', 'tm', ':tabm<Space>')
map('n', 'td', ':tabclose<CR>')

-- LSP Client Config
local on_attach_common = function(client)
    print("LSP started.");

    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
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
require'lspconfig'.pylsp.setup{
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        on_attach_common(client)
    end
}
require'lspconfig'.rust_analyzer.setup{
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        on_attach_common(client)
    end
}
require'lspconfig'.tsserver.setup{
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach_common(client)
    end
}
require'lspconfig'.efm.setup({
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        on_attach_common(client)
    end,
    init_options = {documentFormatting = true},
    filetypes = {"javascript","typescript","typescriptreact","javascriptreact","javascript.jsx","typscript.tsx"},
    settings = {
        languages = {
            javascript = {eslint_d},
            typescript = {eslint_d},
            javascriptreact = {eslint_d},
            typescriptreact = {eslint_d},
        }
    }
})
require'lspfuzzy'.setup{} -- Make the LSP client use FZF instead of quickfix list
map('n', 'gu', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<Leader>w', ':w<CR>')
map('n', '<Leader>w<CR>', ':w<CR>')
map('n', '<Leader>wq', ':wq<CR>')
map('n', '<Leader>wq<CR>', ':wq<CR>')
map('n', '<Leader>q', ':q<CR>')
map('n', '<Leader>q<CR>', ':q<CR>')
map('n', '<Leader>f', ':FZF<CR>')

-- <Tab> to navigate the completion menu
--map('i', '<CR>', 'pumvisible() ? ( empty(v:completed_item) ? "\\<C-n>\\<C-y>" : "\\<C-y>" ) : "\\<CR>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
--map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
--map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly
