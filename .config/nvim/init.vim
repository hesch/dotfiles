filetype plugin indent on
set number
set relativenumber

" install vim-plug, if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
Plug 'Shougo/deoplete.nvim'
Plug 'natebosch/vim-lsc'

" Language plugins
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-markdown'
Plug 'vim-scripts/nginx.vim'

" Color scheme
Plug 'altercation/vim-colors-solarized'

call plug#end()

syntax on
set background=dark
colorscheme solarized

" Rust config
 let g:rustfmt_autosave = 1

" CtrlP config
 let g:ctrlp_cmd = 'CtrlPMixed'

" vim-lsc config
let g:lsc_server_commands = {'rust': 'rls'}
let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \ 'FindReferences': 'gr',
    \ 'NextReference': '*',
    \ 'PreviousReference': '#',
    \ 'FindImplementations': 'gI',
    \ 'FindCodeActions': 'ga',
    \ 'DocumentSymbol': 'go',
    \ 'WorkspaceSymbol': 'gS',
    \ 'ShowHover': 'v:true',
    \ 'SignatureHelp': '<C-m>',
    \ 'Completion': 'completefunc',
    \}
