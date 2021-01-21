" ============================================================================
" set options
" ============================================================================

" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Show mode
set showmode

" Show command
set showcmd

" Enable the mouse in all four modes
set mouse=a

" Encoding
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030

" Number of colors
set t_Co=256

" Background
set background=dark

" Auto indent
set autoindent
set smartindent
set cindent

" Tab
set tabstop=2
set softtabstop=2

" Number of spaces to use for each step of (auto)indent
set shiftwidth=2

" Use the appropriate number of spaces to insert a <Tab>
set expandtab

" Print the line number
set number

" Show the line number relative to the line with the cursor
set relativenumber

" Highlight the screen line of the cursor
set cursorline

" Maximum width of text that is being inserted
set textwidth=80

" Wrap
set wrap

" Wrap long lines at a character in 'breakat'
set linebreak

" Number of characters from the right window border where wrapping starts
set wrapmargin=2

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=5

" The minimal number of screen columns to keep to the left and to the right of
" the cursor if 'nowrap' is set
set sidescrolloff=15

" Show the line and column number of the cursor position
set ruler

" When a bracket is inserted, briefly jump to the matching one
set showmatch

" When there is a previous search pattern, highlight all its matches
set hlsearch

" While typing a search command, show where the pattern, as it was typed so far,
" matches
set incsearch

" Ignore case in search patterns
set ignorecase

" Override the 'ignorecase' option if the search pattern contains upper case
" characters
set smartcase

" Spell checking
" set spell
" set spelllang=en_us

" Don't make a backup before overwriting a file
set nobackup

" Don't use a swapfile for the buffer
set noswapfile

" Saves undo history to an undo file
set undofile

" Directories
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//
set undodir=~/.vim/.undo//

" Auto change directory
set autochdir

" Don't ring the bell
set noerrorbells

" Use visual bell
set visualbell

" A history of ":" commands, and a history of previous search patterns are
" remembered
set history=1000

" When a file has been detected to have been changed outside of Vim and it has
" not been changed inside of Vim, automatically read it again
set autoread

" Strings to use in 'list' mode and for the |:list| command
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" set list

" Command-line completion
set wildmenu
set wildmode=longest:list,full

" A sequence of letters which describes how automatic formatting is to be done
set formatoptions+=m

" Keywords are used in searching and recognizing with many commands
set iskeyword+=.,_,$,@,%,#,-

" Use the clipboard register '*' for all yank, delete, change and put operations
" which would normally go to the unnamed register
set clipboard+=unnamed

" Language
set langmenu=zh_CN.UTF-8
set helplang=cn

" Unsaved changes confirmation
set confirm

" Start select mode when using mouse or using shifted special keys
set selectmode=mouse,key

" Allow specified keys that move the cursor left/right to move to the
" previous/next line when the cursor is on the first/last character in the line
set whichwrap+=<,>

" Lazy redraw
set lazyredraw

" Always show status line
set laststatus=2

" Status line
set statusline=\ %F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\

" Time out
set ttimeout

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Ignored file patterns
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" Syntax highlighting
syntax enable

" Enable file type detection, plugin, indent
filetype plugin indent on

" ============================================================================
" commands
" ============================================================================

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

" ============================================================================
" autocmds
" ============================================================================

augroup vimrcReload
  autocmd!
  " Reload .vimrc
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup vimStartup
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim) and for a commit message (it's
  " likely a different one than last time).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" https://vi.stackexchange.com/questions/25103/neovim-does-not-restore-terminal-cursor-on-exit
augroup restoreCursorShapeOnExit
  autocmd!
  autocmd VimLeave * set guicursor=a:hor20-blinkwait175-blinkoff150-blinkon175
augroup END

" Define function SetTitle
" func SetTitle()
"   "
" endfunc

" augroup newFiles
"   autocmd!
"   " Call function SetTitle for specific files
"   autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()"
"   " Go to the last line of new file
"   autocmd BufNewFile * normal G
" augroup END

" ============================================================================
" key mapping
" ============================================================================

"

" ============================================================================
" optional packages
" ============================================================================

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
" if !has('nvim')
"   packadd! matchit
" endif

" ============================================================================
" neovim
" ============================================================================

if has('nvim')
  " let g:python_host_prog = system('echo -n $(command -v python2)')
  let g:python3_host_prog = system('echo -n $(command -v python3)')
endif

" ============================================================================
" vim-plug
" ============================================================================

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" vim-plug
" Plug 'junegunn/vim-plug'

" editorconfig
Plug 'editorconfig/editorconfig-vim'

" nerdtree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" tagbar
Plug 'majutsushi/tagbar'

" vimade
Plug 'TaDaa/vimade'

" ctrlp
Plug 'ctrlpvim/ctrlp.vim'

" icons
Plug 'ryanoasis/vim-devicons'

" completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  if has('python3')
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
endif
Plug 'mattn/emmet-vim'
" Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

" integration
Plug 'mileszs/ack.vim'
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'tpope/vim-dispatch'

" interface
" Plug '/usr/local/opt/fzf'
" Plug 'junegunn/fzf.vim'
" Plug 'wincent/command-t'

" commands
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'terryma/vim-expand-region'
Plug 'easymotion/vim-easymotion'
Plug 'chrisbra/nrrwrgn'
Plug 'Yggdroot/indentLine'

" powerline
" Plug 'powerline/powerline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'itchyny/lightline.vim'
" Plug 'maximbaz/lightline-ale'

" snippets
Plug 'honza/vim-snippets'
if has('python3')
  Plug 'garbas/vim-snipmate'
  Plug 'sirver/ultisnips'
endif

" lint
Plug 'dense-analysis/ale'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-rhubarb'

" languages
Plug 'scrooloose/nerdcommenter'
" Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'

" html
Plug 'adelarsq/vim-matchit'
if has('python3')
  Plug 'valloric/matchtagalways'
endif
" Plug 'othree/html5.vim'

" javascript
" Plug 'pangloss/vim-javascript'
" Plug 'mxw/vim-jsx'

" typescript
" Plug 'leafgarland/typescript-vim'

" ruby
" Plug 'vim-ruby/vim-ruby'
" Plug 'tpope/vim-rails'

" go
" Plug 'fatih/vim-go'

" markdown
" Plug 'plasticboy/vim-markdown'
" Plug 'tpope/vim-markdown'

" nginx
" Plug 'nginx/nginx'
" Plug 'chr4/nginx.vim'

" json
" Plug 'elzr/vim-json'

" code display
" Plug 'sjl/gundo.vim'

" others
Plug 'marcweber/vim-addon-mw-utils'
" Plug 'kkoomen/vim-doge'
" Plug 'terryma/vim-multiple-cursors'

" Themes
Plug 'joshdick/onedark.vim'
" Plug 'tomasr/molokai'
" Plug 'altercation/vim-colors-solarized'

call plug#end()

" ============================================================================
" plugin & theme settings
" ============================================================================

" editorconfig/editorconfig-vim
" ----------------------------------------------------------------------------
" To ensure that this plugin works well with tpope/vim-fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

" scrooloose/nerdtree
" ----------------------------------------------------------------------------
let NERDTreeShowHidden=1

" Open NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>

augroup nerdTree
  autocmd!

  " Open a NERDTree automatically when vim starts up
  " autocmd vimenter * NERDTree
  " Open a NERDTree automatically when vim starts up if no files were specified
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  " Open NERDTree automatically when vim starts up on opening a directory
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
  " Close vim if the only window left open is a NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" majutsushi/tagbar
" ----------------------------------------------------------------------------
map <C-b> :TagbarToggle<CR>

" ctrlpvim/ctrlp.vim
" ----------------------------------------------------------------------------
let g:ctrlp_working_path_mode = 'ra'

let g:ctrlp_custom_ignore = {
  \   'dir':  '\v[\/]\.(git|hg|svn)$',
  \   'file': '\v\.(exe|so|dll)$'
  \ }

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Shougo/deoplete.nvim
" ----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1

" vim-airline/vim-airline
" ----------------------------------------------------------------------------
" Integrating with powerline fonts
let g:airline_powerline_fonts = 1
" Automatically displays all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1
" vim-airline integrates with dense-analysis/ale for displaying error information in the status bar
let g:airline#extensions#ale#enabled = 1
" Using a Theme
" let g:airline_theme='murmur'

" itchyny/lightline.vim maximbaz/lightline-ale
" ----------------------------------------------------------------------------
let g:lightline = {
  \   'colorscheme': 'one',
  \   'component_function': {
  \     'gitbranch': 'fugitive#head'
  \   },
  \   'active': {
  \     'left': [
  \       [ 'mode', 'paste' ],
  \       [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \     ],
  \     'right': [
  \       [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
  \       [ 'lineinfo' ],
  \       [ 'percent' ],
  \       [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ]
  \     ]
  \   }
  \ }

let g:lightline.component_expand = {
  \   'linter_checking': 'lightline#ale#checking',
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \   'linter_ok': 'lightline#ale#ok'
  \ }

let g:lightline.component_type = {
  \   'linter_checking': 'left',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'left'
  \ }

let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "

" dense-analysis/ale
" ----------------------------------------------------------------------------
" Use ALE and also some plugin 'foobar' as completion sources for all code.
" call deoplete#custom#option('sources', {
"   \   '_': ['ale', 'foobar'],
"   \ })

" scrooloose/nerdcommenter
" ----------------------------------------------------------------------------
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
" let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
" let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" garbas/vim-snipmate
" ----------------------------------------------------------------------------
" Remote the start up message
let g:snipMate = { 'snippet_version' : 1 }

" theme
" ----------------------------------------------------------------------------
" molokai
silent! colorscheme molokai

" ============================================================================
" help tags
" ============================================================================
" Put these lines at the very end of your vimrc file.

" Load all plugins now. Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded. All messages and errors will be ignored.
silent! helptags ALL
