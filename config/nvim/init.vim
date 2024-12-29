syntax on
filetype on

set visualbell t_vb=
set nobackup nowritebackup
set history=8000
set termguicolors
set hidden
set grepprg=rg\ --vimgrep
set background=light
set fillchars+=vert:\│
set maxmempattern=2000000
set synmaxcol=200000
set path+=**
set wildmenu
set number relativenumber
set lazyredraw undofile
set timeoutlen=3000
set sw=4

command! RLine execute 'normal! '.(system('/bin/bash -c "echo -n $RANDOM"') % line('$')).'G'

augroup vimrc
    " Clear existing autocommands before recreate
    autocmd!

    if $TMUX != ""
        " in tmux, update window title with edited filename
        au BufEnter *
            \ if stridx(expand("%:t"), "VSVim") == -1
            \ |     call system("tmux rename-window "
            \ 			. shellescape("vi "
            \ 			. expand("%:t")
            \ 			. "│"
            \ 			. fnamemodify(getcwd(), ":t")))
            \ | endif
    endif

    au BufRead,BufNewFile *.gradle setlocal ft=groovy
    au BufRead,BufNewFile *.wsgi,*.py
                \ setlocal ft=python
                \ | set sts=4 sw=4 expandtab autoindent fileformat=unix

    au BufRead,BufNewFile *.sql
                \ setlocal ignorecase

    au FileType haskell setlocal sw=2
    au FileType gitcommit
        \ au! BufEnter COMMIT_EDITMSG setlocal formatoptions+=n

    au BufRead,BufNewFile *.txt set ft=none
augroup END

set formatlistpat=^\\s*\\(\\d\\+\\\|[*#-]\\)[\\]:.)}\\t\ ]\\s*
set hlsearch incsearch ruler laststatus=2
set shiftwidth=4 softtabstop=4 expandtab autoindent

nnoremap <Space>y "+y
nnoremap <Space>p "+p
cnoremap <C-g> <C-c>

" Delete to backspace in all modes:
nnoremap <Char-0x7f> <BS>
inoremap <Char-0x7f> <BS>
cnoremap <Char-0x7f> <BS>

let g:sql_type_default = 'pgsql'

call plug#begin('~/.vim/plugged')
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'Olical/vim-enmasse'
Plug 'axelf4/vim-strip-trailing-whitespace'
Plug 'bkad/CamelCaseMotion'
Plug 'bronson/vim-visual-star-search'
Plug 'dhruvasagar/vim-table-mode'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'junegunn/vim-easy-align'
Plug 'lifepillar/pgsql.vim'
Plug 'mattn/emmet-vim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

Plug 'michaeljsmith/vim-indent-object'
Plug 'romgrk/github-light.vim'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'pangloss/vim-javascript'
Plug 'sheerun/vim-polyglot'
Plug 'tommcdo/vim-express'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'wellle/targets.vim'
call plug#end()

colorscheme github-light

let g:jsx_ext_required=0
let mapleader='\'

let g:csv_no_conceal = 1

:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g

" binds <leader> + w, b, e, ge:
call camelcasemotion#CreateMotionMappings('<Leader>')

map Q <Plug>(easymotion-prefix)
nmap <silent> dsf ds)db
nnoremap <Leader>- :set nonumber norelativenumber<CR>
nnoremap <Leader>= :set number relativenumber<CR>
nnoremap <Leader>\ :Files<CR>
nnoremap <Leader>f :Buffers<CR>
nnoremap <Leader>ev :e ~/.vim/init.vim<CR>
nnoremap <Leader>evs :source ~/.vim/init.vim<CR>
nnoremap <silent> <Leader>G :<C-u>cd %:p:h<CR>:echo "Changed directory to " . getcwd()<CR>
nnoremap & :&&<CR>
xnoremap & :&&<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

inoremap <C-X><C-Q> </<C-X><C-O>

" Practical Vim idea: make ^L also :nohls
nnoremap <silent> <C-L> :<C-u>nohlsearch<CR><C-L>

lua <<LSP_CONFIG
local configured_lsps = {
    "rust_analyzer",
    "lua_ls", -- lua-language-server
    "pyright",
}

vim.opt.signcolumn = 'yes'

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function (event)
        local opts = {buffer = event.buf}
        local key = vim.keymap.set
        key('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        key('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        key('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        key('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        key('n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        key('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        key('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        key('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        key({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        key('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        key('i', '<C-x><C-o>', '<cmd>lua require("cmp").mapping.complete()<cr>', opts)
    end,
})

local cmp = require('cmp')
cmp.setup({
    sources = cmp.config.sources({{name = "nvim_lsp"}}, {{name = "buffer"}}),
    mapping = cmp.mapping.preset.insert({
        ['<C-space>'] = cmp.mapping.complete(),
        ['<cr>'] = cmp.mapping.confirm({select = true}),
        ['<Tab>'] = cmp.mapping.confirm({select = true}),
        ['<C-c>'] = cmp.mapping.abort(),
    }),
    snippet = {
        expand = function (args)
            vim.snippet.expand(args.body)
        end,
    },
})

cmp_nvim_lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
for i, analyzer in ipairs(configured_lsps) do
    require('lspconfig')[analyzer].setup({ completion = cmp_nvim_lsp_capabilities })
end
LSP_CONFIG
