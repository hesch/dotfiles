filetype plugin indent on
set number
set relativenumber

let s:macos = has("unix") && (system("uname") == "Darwin\n")

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
Plug 'editorconfig/editorconfig-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

Plug 'sbdchd/neoformat'
Plug 'mileszs/ack.vim'

" Language plugins
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-markdown'
Plug 'vim-scripts/nginx.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'OmniSharp/omnisharp-vim'

" Color scheme
if s:macos
  Plug 'altercation/vim-colors-solarized'
else
  Plug 'frankier/neovim-colors-solarized-truecolor-only'
endif

call plug#end()

let g:deoplete#enable_at_startup = 1

if !s:macos
  set termguicolors
  let g:solarized_termcolors=256
endif

syntax on
set background=dark
colorscheme solarized

" ack config
function! Find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! -nargs=1 Ag execute "Ack <args> " . Find_git_root()

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" gitgutter config
if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" Rust config
let g:rustfmt_autosave = 1

" CtrlP config
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" vim-lsc config
let g:lsc_server_commands = {'rust': 'rls'}
let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \ 'FindReferences': 'gr',
    \ 'NextReference': '*',
    \ 'PreviousReference': '#',
    \ 'FindImplementations': 'gI',
    \ 'FindCodeActions': 'ga',
    \ 'DocumentSymbol': 'K',
    \ 'WorkspaceSymbol': 'gS',
    \ 'ShowHover': 'v:true',
    \ 'SignatureHelp': '<C-m>',
    \ 'Completion': 'completefunc',
    \}

  call deoplete#custom#option('sources', {
    \ 'cs': ['omnisharp'],
    \ })

autocmd filetype cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
autocmd filetype cs nnoremap <buffer> gI :OmniSharpFindImplementations<CR>
autocmd filetype cs nnoremap <buffer> K :OmniSharpDocumentation<CR>
autocmd filetype cs nnoremap <buffer> ga :OmniSharpGetCodeActions<CR>
autocmd filetype cs nnoremap <buffer> <leader>cu :OmniSharpFixUsings<CR>

autocmd filetype typescript nnoremap <buffer> gd :TSDef<CR>

set updatetime=100

" NERDTree
" let g:NERDTreeDirArrowExpandable = ''
" let g:NERDTreeDirArrowCollapsible = ''

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

" some settings
set shiftwidth=2
set smartindent

" typescript
" let g:nvim_typescript#type_info_on_hold = 1
let g:nvim_typescript#default_mappings = 1

" Shortcuts
let mapleader=" "

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Right> <Nop>
noremap <Left> <Nop>

nnoremap <leader>a :NERDTreeToggle<CR>
nnoremap <leader>s :NERDTreeFind<CR>

nnoremap <leader>ti :TSImport<CR>
