call plug#begin('~/.local/share/nvim/plugged')

Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}

if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'dyng/ctrlsf.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'takkii/Bignyanco'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ap/vim-buftabline'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'vim-ruby/vim-ruby'
Plug 'thoughtbot/vim-rspec'
Plug 'dyng/ctrlsf.vim'

set hidden

let g:LanguageClient_serverCommands = { 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'] }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

:au FocusLost * silent! wa

call plug#end()

no d h
no h j
no t k
no n l

no j d
no k t
no l n

noremap <C-D> <C-W><C-H>
nnoremap <C-H> <C-W><C-J>
nnoremap <C-T> <C-W><C-K>
nnoremap <C-N> <C-W><C-L>

colorscheme Tomorrow-Night-Eighties

let NERDTreeMapOpenInTab='\t'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

set expandtab
set tabstop=2 shiftwidth=2
set nocompatible
set mouse=a
syntax enable
syntax on
filetype plugin indent on
set showcmd
set encoding=utf-8
set number
set nohlsearch

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
map <C-f> :Ag<CR>
map <C-P> :FZF<CR>
map <C-x> :!pbcopy<CR>
map <C-c> :w !pbcopy<CR><CR>
let g:fzf_action = {
  \ 'ctrl-c': 'tab split',
  \ 'ctrl-n': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
