"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Settings
" by Sebastian Qu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get OS Version
function! MySys()
  return "linux"
  "return "win32"
endfunction

"Get Os Language
function! MyLang()
  return "chs"
  "return "jpn"
endfunction

"Get out of VI's compatible mode..
set nocompatible

"Sets how many lines of history VIM har to remember
set history=400

"Enable filetype plugin
filetype plugin on
filetype indent on

"Set to auto read when a file is changed from the outside
set autoread

"Have the mouse enabled all the time:
set mouse=a

"Set mapleader
let mapleader = ","
let g:mapleader = ","

"Fast saving
nmap <leader>w :w!<cr>
nmap <leader>f :find<cr>

"Fast reloading of the vimrc
if MySys() == "win32"
    "Fast reloading of the .vimrc(For Win32)
    map <silent> <leader>s :source $VIM\_vimrc<cr>
    "Fast editing of .vimrc(For Win32)
    map <silent> <leader>e :e $VIM\_vimrc<cr>
    "When .vimrc is edited, reload it(For Win32)
    autocmd! bufwritepost .vimrc source $VIM\_vimrc
elseif MySys() == "linux"
    "Fast reloading of the .vimrc(For *nux)
    map <leader>s :source ~/.vimrc<cr>
    "Fast editing of .vimrc(For *nux)
    map <leader>e :e! ~/.vimrc<cr>
    "When .vimrc is edited, reload it(Fo *nux)
    autocmd! bufwritepost vimrc source ~/.vimrc
endif

"internationalization
if MySys() == "win32"
    if MyLang() == "chs"
      set helplang=cn
      set encoding=cp936
      set fileencoding=cp936
    else
      set encoding=cp932
      set fileencoding=cp932
      set iminsert=0
      set imsearch=0
    endif
    set fileencodings=utf-8,usc-bom,cp932,gb18030,gbk,gb2312,cp936
else
    set helplang=cn
    set fileencoding=utf-8
    set fileencodings=utf-8,ucs-bom,gb1830,gbk,gb2312,cp936
    set langmenu=zh_CN.UTF-8
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable syntax hl
syntax enable

if has("gui_running")
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R

    if MySys()=="win32"
        "start gvim maximized
        if has("autocmd")
            au GUIEnter * simalt ~x
        endif
    endif
endif

" Color Theme
if has("gui_running") 
  colo evening
else
  if exists('$TMUX')
    set term=xterm-256color
  endif

  set background=dark
  colo solarized
endif

" set cursor shape at tmux
if exists('$ITERM_PROFILE')
  if exists('$TMUX') 
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  endif
endif


" highlight currentline
if has("gui_running")
  set cursorline
  "set cursorcolumn
  hi CursorLine guibg=#444444
  "hi CursorColumn guibg=#444444
endif

"Omni menu colors
hi Pmenu guibg=#333333
hi PmenuSel guibg=#555555 guifg=#ffffff

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fileformats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix,dos,mac

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM userinterface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set 7 lines to the curors - when moving vertical..
set so=7

"Turn on WiLd menu
set wildmenu

"Always show current position
set ruler

"The commandbar is 2 high
set cmdheight=2

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"Change buffer - without saving
set hid

"Set backspace
set backspace=eol,start,indent

"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

"Ignore case when searching
set ignorecase
set incsearch

"Set magic on
set magic

"No sound on errors.
set noerrorbells
set novisualbell
set t_vb=

"How many tenths of a second to blink
set mat=2

"Highlight search things
set hlsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moving around and tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Map space to / and c-space to ?
map <space> /
map <c-space> ?

"Actually, the tab does not switch buffers, but my arrows
"Bclose function ca be found in "Buffer related" section
map <leader>bd :Bclose<cr>

"Tab configuration
map <leader>tn :tabnew %<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
try
  set switchbuf=usetab
  set stal=2
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Switch to current dir
map <leader>cd :cd %:p:h<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing mappings etc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

set completeopt=menu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command-line config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! Cwd()
    let cwd = getcwd()
    return "e " . cwd 
endfunc

func! DeleteTillSlash()
    let g:cmd = getcmdline()
    if MySys() == "linux" || MySys() == "mac"
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    endif
    if g:cmd == g:cmd_edited
        if MySys() == "linux" || MySys() == "mac"
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        endif
    endif
    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./

cno $q <C-\>eDeleteTillSlash()<cr>

cno $c e <C-\>eCurrentFileDir("e")<cr>

cno $tc <C-\>eCurrentFileDir("tabnew")<cr>
cno $th tabnew ~/
cno $td tabnew ~/Desktop/

"Bash like
cnoremap <C-A>    <Home>
cnoremap <C-E>    <End>
cnoremap <C-K>    <C-U>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer realted
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Open a dummy buffer for paste
map <leader>q :e ~/buffer<cr>

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Buffer - reverse everything ... :)
map <F9> ggVGg?

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()

function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn backup off
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable folding, I find it very useful
set nofen
set fdl=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces extends tabstop
set expandtab
set shiftwidth=4
set tabstop=4

map <leader>t2 :set shiftwidth=2<cr>
map <leader>t4 :set shiftwidth=4<cr>
au FileType python,vim,ruby,eruby,css,scss setl shiftwidth=2
au FileType python,vim,ruby,eruby,css,scss setl tabstop=2

set smarttab
set lbr
set tw=500

    """"""""""""""""""""""""""""""
    " Indent
    """"""""""""""""""""""""""""""
    "Auto indent
    set ai

    "Smart indet
    set si

    "C-style indeting
    "set cindent

    "Wrap lines
    set wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set guifont=Inconsolata\ for\ Powerline:h15
    filetype off

    """"""""""""""""""""""""""""""
    " Vundle
    """"""""""""""""""""""""""""""
    set rtp+=~/.vim/bundle/Vundle.vim/

    " Installed plugin list
    call vundle#begin()      
    
    " Plugin Manager
    Plugin 'VundleVim/Vundle.vim'

    " addition window plugin
    Plugin 'bling/vim-airline'
    Plugin 'ctrlpvim/ctrlp.vim'
    Plugin 'scrooloose/nerdtree'
    Plugin 'Xuyuanp/nerdtree-git-plugin'
    Plugin 'Gundo'
    Plugin 'majutsushi/tagbar' 
    Plugin 'airblade/vim-gitgutter'
    Plugin 'tpope/vim-fugitive'
    Plugin 'mhinz/vim-startify'

    "Plugin 'pydoc.vim'
    "Plugin 'vim-ruby/vim-ruby'

    " develop support
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'scrooloose/syntastic'
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    Plugin 'rizzatti/funcoo.vim'
    Plugin 'rizzatti/dash.vim'

    " language support
    Plugin 'keith/swift.vim'

    " others
    Plugin 'ryanoasis/vim-devicons'

    call vundle#end()       
    filetype plugin indent on

    """"""""""""""""""""""""""""""
    " airline 
    """"""""""""""""""""""""""""""
    set laststatus=2
    let g:airline_powerline_fonts = 1
    let g:airline_theme = "wombat"
    let g:airline#extensions#tabline#enabled = 1 
    let g:airline#extensions#tagbar#endalbed = 1

    """"""""""""""""""""""""""""""
    " airline gitgutter extension
    """"""""""""""""""""""""""""""
    let g:airline#extensions#branch#enabled = 1
    let g:airline#extensions#hunks#enabled = 1
    let g:airline#extensions#hunks#none_zero_only = 0
    let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
    let g:airline_section_c='%{getcwd()}'

    """"""""""""""""""""""""""""""
    " ctrlp
    """"""""""""""""""""""""""""""
    set runtimepath^=~/.vim/bundle/ctrlp.vim
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.png,*.jpg,*.jpeg,*.gif " MacOSX/Linux
    let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

    if executable('ag')
      "use ag over grep
      set grepprg=ag\ --nogroup\ --nocolor
      "use ag in ctrlp for listing files
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
      " Ag is fast enough that ctrlp doesn't need to cache
      let g:ctrlp_use_caching=0
    endif
    
    """"""""""""""""""""""""""""""
    " nerdtree-git-plugin
    """"""""""""""""""""""""""""""
    let g:NERDTreeIndicatorMapCustom = {
      \ "Modified"  : "✹",
      \ "Staged"    : "✚",
      \ "Untracked" : "✭",
      \ "Renamed"   : "➜",
      \ "Unmerged"  : "═",
      \ "Deleted"   : "✖",
      \ "Dirty"     : "✗",
      \ "Clean"     : "✔︎",
      \ "Unknown"   : "?"
      \ }

    let g:ctrlp_cmd='CtrlPMRU'

    """"""""""""""""""""""""""""""
    " Gundo
    """"""""""""""""""""""""""""""
    map <leader>gd :GundoToggle<cr>

    """"""""""""""""""""""""""""""
    " tagbar
    """"""""""""""""""""""""""""""
    let g:tagbar_width=35
    let g:tagbar_autofocus=1
    nmap <F8> :TagbarToggle<CR>

    """"""""""""""""""""""""""""""
    " YouCompleteMe
    """"""""""""""""""""""""""""""
    let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    let g:ycm_always_populate_location_list = 1
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_extra_conf_vim_data = ['&filetype']
    let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdonw' : 1,
      \ 'vimwiki' : 1,
      \ 'gitcommit' : 1
      \ }

    let g:ycm_semantic_triggers =  {
      \   'c' : ['->', '.'],
      \   'objc' : ['->', '.', '\[[_a-zA-Z]+\w*\s'],
      \   'ocaml' : ['.', '#'],
      \   'cpp,objcpp' : ['->', '.', '::'],
      \   'perl' : ['->'],
      \   'php' : ['->', '::'],
      \   'cs,java,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
      \   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
      \   'ruby' : ['.', '::'],
      \   'lua' : ['.', ':'],
      \   'erlang' : [':'],
      \ }

    let g:ycm_error_symbol = '✗'

    """"""""""""""""""""""""""""""
    " Syntastic
    """"""""""""""""""""""""""""""
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticsStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 0
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    "let g:syntastic_objc_config_file = '.clang_complete'
    let g:syntastic_javascript_checkers=['jscs']
    let g:syntastic_html_checkers = [] " don't check .html files
    
    """"""""""""""""""""""""""""""
    " vim snippets
    """"""""""""""""""""""""""""""
    let g:UltiSnipsExpandTrigger="<c-tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"

    """"""""""""""""""""""""""""""
    " vim-startify
    """"""""""""""""""""""""""""""
    let g:startify_list_order = [
          \ ['   MRU '],       'files' ,
          \ ['   MRU DIR '],   'dir',
          \ ['   Sessions '],  'sessions',
          \ ['   Bookmarks '], 'bookmarks',
          \ ]

    let g:startify_skiplist = [
          \ 'COMMIT_EDITMSG',
          \ 'bundle/.*/doc',
          \ '*.vim'
          \ ]

    function! s:filter_header(lines) abort
        let longest_line   = max(map(copy(a:lines), 'len(v:val)'))
        let centered_lines = map(copy(a:lines),
            \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
        return centered_lines
    endfunction
    let g:startify_custom_header = s:filter_header(map(split(system('fortune | cowsay'), '\n'), '"   ". v:val') + ['',''])


    let g:startify_bookmarks              = [ {'c': '~/.vim/vimrc'} ]
    let g:startify_change_to_dir          = 0
    let g:startify_enable_special         = 0
    let g:startify_files_number           = 8
    let g:startify_session_autoload       = 1
    let g:startify_session_delete_buffers = 1
    let g:startify_session_persistence    = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype generic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""
    " HTML related
    """"""""""""""""""""""""""""""
    " HTML entities - used by xml edit plugin
    let xml_use_xhtml = 1
    "let xml_no_auto_nesting = 1

    "To HTML
    let html_use_css = 1
    let html_number_lines = 0
    let use_xhtml = 1

