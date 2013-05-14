" VIM, no Vi
set nocompatible

let mapleader=","

" semi-colon removes search highlights
map ; :nohlsearch<CR>

" Disable swap files
set noswapfile

set grepprg=ack
set grepformat=%f:%l:%m
set formatprg=par\ -w116

" Check the file's content for options
set modeline
set modelines=2

set hidden
set wildmenu
set wildmode=list:longest,full
set ignorecase
set smartcase
set title
set scrolloff=3
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set ruler
set number
set showcmd
set showmatch
set lazyredraw
set copyindent
set nobackup

" Don't wrap lines longer than the window's width
set nowrap
set linebreak
set sidescroll=5
set listchars+=precedes:<,extends:>

" Intuitive backspacing in insert mode
set backspace=indent,eol,start

" File-type highlighting and configuration.
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
call pathogen#runtime_append_all_bundles()
syntax on
filetype on
filetype plugin on
filetype indent on

autocmd FileType c        setlocal noexpandtab shiftwidth=8 softtabstop=8 tabstop=8 noautoindent smartindent 
autocmd FileType make     setlocal noexpandtab

autocmd BufNewFile,BufRead *.dryml setfiletype xml
autocmd BufNewFile,BufRead Gemfile setfiletype ruby

" Highlight search terms...
set hlsearch
set incsearch " ...dynamically as they are typed.

set list
set listchars=tab:▸\ ,trail:·,eol:¬,extends:#,nbsp:.

set shortmess=atI
set visualbell
set noerrorbells

set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

map <Leader>x :set filetype=xml

" NERD_tree
map <Leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" scratch.vim
function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""
" Indenting
""""""""""""""""""""""""""""""""""""""""""""""""

"Default to autoindenting of C like languages
"This is overridden per filetype below
set noautoindent smartindent

"The rest deal with whitespace handling and
"mainly make sure hardtabs are never entered
"as their interpretation is too non standard in my experience
set softtabstop=2
set tabstop=2
" Note if you don't set expandtab, vi will automatically merge
" runs of more than tabstop spaces into hardtabs. Clever but
" not what I usually want.
set expandtab
set shiftwidth=2
set shiftround
set nojoinspaces
set smarttab

""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax highlighting
""""""""""""""""""""""""""""""""""""""""""""""""

"Syntax highlighting if appropriate
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
    set incsearch "For fast terminals can highlight search string as you type
endif

if &diff
    "I'm only interested in diff colours
    syntax off
endif

"syntax highlight shell scripts as per POSIX,
"not the original Bourne shell which very few use
let g:is_posix = 1

"flag problematic whitespace (trailing and spaces before tabs)
"Note you get the same by doing let c_space_errors=1 but
"this rule really applys to everything.
highlight RedundantSpaces term=standout ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted
"use :set list! to toggle visible whitespace on/off
set listchars=tab:>-,trail:.,extends:>

""""""""""""""""""""""""""""""""""""""""""""""""
" Key bindings
""""""""""""""""""""""""""""""""""""""""""""""""

"allow deleting selection without updating the clipboard (yank buffer)
vnoremap x "_x
vnoremap X "_X

"<home> toggles between start of line and start of text
imap <khome> <home>
nmap <khome> <home>
inoremap <silent> <home> <C-O>:call Home()<CR>
nnoremap <silent> <home> :call Home()<CR>
function Home()
    let curcol = wincol()
    normal ^
    let newcol = wincol()
    if newcol == curcol
        normal 0
    endif
endfunction

"<end> goes to end of screen before end of line
imap <kend> <end>
nmap <kend> <end>
inoremap <silent> <end> <C-O>:call End()<CR>
nnoremap <silent> <end> :call End()<CR>
function End()
    let curcol = wincol()
    normal g$
    let newcol = wincol()
    if newcol == curcol
        normal $
    endif
    "The following is to work around issue for insert mode only.
    "normal g$ doesn't go to pos after last char when appropriate.
    "More details and patch here:
    "http://www.pixelbeat.org/patches/vim-7.0023-eol.diff
    if virtcol(".") == virtcol("$") - 1
        normal $
    endif
endfunction

"Ctrl-{up,down} to scroll.
"The following only works in gvim?
"Also vim doesn't have default C-{home,end} bindings?
"if has("gui_running")
"    nmap <C-up> <C-y>
"    imap <C-up> <C-o><C-y>
"    nmap <C-down> <C-e>
"    imap <C-down> <C-o><C-e>
"endif

" colorscheme torte
colorscheme vividchalk

" Map \r to run current file with ruby
" Copied from http://github.com/giraffesoft/dotfiles/blob/4039f7e3811957a378692a9b223c5f5108290b6d/vimrc
nmap <Leader>r :!ruby %<CR>

" align plugin stuff
call Align#AlignCtrl('W=|p1P1')
map <Leader>aa :Align =><CR>
map <Leader>ab :Align =<CR>
 
" window splitting mappings
nmap <Leader>v :vsplit<CR> <C-w><C-w>
nmap <Leader>s :split<CR> <C-w><C-w>

" <leader>S opens a scratch buffer
nmap <Leader>S :Scratch<CR>

" Activate yaml plugin on .yaml or .yml
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/plugin/yaml.vim

nmap <Leader>n :set number<CR>

set ttimeoutlen=10
set timeoutlen=150

" Auto-center the view on the next search term
nmap n nzz
nmap N Nzz

set foldmethod=manual
set foldnestmax=10
set nofoldenable
set foldlevel=1

" Settings for VimClojure
let g:clj_highlight_builtins=1      " Highlight Clojure's builtins
let g:clj_paren_rainbow=1           " Rainbow parentheses'!

" Edit routes
command! Rroutes :Redit config/routes.rb
command! RSroutes :RSedit config/routes.rb
command! RVroutes :RVedit config/routes.rb
command! RTroutes :RTedit config/routes.rb

command! Rschema :Redit db/schema.rb
command! RSschema :RSedit db/schema.rb
command! RTschema :RTedit db/schema.rb

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
