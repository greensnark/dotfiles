syntax on
filetype on

set visualbell t_vb=
set nobackup nowritebackup
set history=8000
set termguicolors
set hidden
set grepprg=rg\ --vimgrep
set background=light
if has('mac')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif
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
    au BufRead,BufNewFile *.go
        \ setlocal ts=4
        \ | nnoremap <buffer> <Leader>i :GoInstall .<CR>
        \ | nnoremap <buffer> <Leader>B :GoBuild .<CR>

    au BufRead,BufNewFile *.sql
                \ setlocal ignorecase

    au FileType haskell setlocal sw=2
    au FileType gitcommit
        \ au! BufEnter COMMIT_EDITMSG setlocal formatoptions+=n

    au BufRead,BufNewFile *.txt set ft=none

    au FileType rust
        \ nmap gd <Plug>(rust-def)
        \ | nmap gs <Plug>(rust-def-split)
        \ | nmap gx <Plug>(rust-def-vertical)
        \ | nmap <Leader>gd <Plug>(rust-doc)
augroup END

set formatlistpat=^\\s*\\(\\d\\+\\\|[*#-]\\)[\\]:.)}\\t\ ]\\s*
set hlsearch incsearch ruler laststatus=2
set shiftwidth=4 softtabstop=4 expandtab autoindent

" Configure vim with correct 24-bit color escapes for st (neovim doesn't need these):
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Cursor shapes for Start Insert, Start Replace and End Insert, vim only,
" neovim discovers these automatically from terminfo
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[1 q"

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
Plug 'mattn/vim-lsp-settings'
Plug 'michaeljsmith/vim-indent-object'
Plug 'romgrk/github-light.vim'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'pangloss/vim-javascript'
Plug 'prabirshrestha/vim-lsp'
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

let g:rustfmt_autosave = 1

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
nnoremap <Space> <C-D>
nnoremap & :&&<CR>
xnoremap & :&&<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

inoremap <C-X><C-Q> </<C-X><C-O>

" Practical Vim idea: make ^L also :nohls
nnoremap <silent> <C-L> :<C-u>nohlsearch<CR><C-L>

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
