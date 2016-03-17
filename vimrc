"Basic setup {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldmethod=marker spell:
    set nocompatible        " Must be first line
    filetype on
    filetype off
    set rtp+=~/.vim/bundle/vundle
    call vundle#rc()
    source ~/.vim/vimrc.bundles
"}

" General {
    set t_Co=256                " Force use 256 color terminal
    set term=xterm-256color

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has ('x') && has ('gui') " On Linux use + register for copy-paste
        set clipboard=unnamedplus
    elseif has ('gui')          " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif

    set shortmess+=filmnrxoOtT           " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore              " Allow for cursor beyond last character
    set history=1000                     " Store a ton of history (default is 20)
    set hidden                           " Allow buffer switching without saving
    set nospell                          " Disable spelling (very confusing)
    autocmd BufEnter * silent! lcd %:p:h " Change current directory to opened file's

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
                    \ '\[example pattern\]'
                    \ ]
    " }

" }

" Vim UI {
    if has('gui_running')
        color molokai
    else
        set background=dark         " Assume a dark background
        let g:solarized_termcolors=256
        color solarized                 " Load a colorscheme
        let g:solarized_termtrans=1
        let g:solarized_contrast="high"
        let g:solarized_visibility="high"
    endif
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line


    highlight iCursor guifg=white guibg=steelblue

    highlight clear SignColumn      " SignColumn should match background for
                                    " things like vim-gitgutter

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        let g:airline_powerline_fonts = 1
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'
        let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {

    set showmatch                    " Match parenthesis
    set nowrap                      " Wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=2                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set smarttab
    set tabstop=2                   " An indentation every four columns
    set softtabstop=2               " Let backspace delete indent
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig

" }

" Key (re)Mappings {

    " Set leader as ,
    let mapleader = ','

    " Help on topic
    nnoremap <silent> <F1> :call SophHelp()<CR>
    imap <F1> <Esc><F1>


    " Switch to alternative file (e.g. to .h from .cpp)
    nmap <F4> :silent! FSHere<CR>
    imap <F4> <ESC>:silent! FSHere<CR>

    nmap <F5> :bp<CR>
    imap <F5> <ESC>:bp<CR>
    nmap <F6> :bn<CR>
    imap <F6> <ESC>:bn<CR>

    if has('gui_running')
        nmap <C-Tab> :bn<CR>
        imap <C-Tab> <ESC>:bn<CR>
        nmap <C-S> :w<CR>
        imap <C-S> <ESC>:w<CR>
        cnoreabbrev wq w<bar>bd
    endif

    " F3 to toggle location list
    let g:toggle_list_no_mappings = 1
    nmap <silent> <F3> :call ToggleLocationList()<CR>
    imap <silent> <F3> :call ToggleLocationList()<CR>

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Toggle search highlighting
    nmap <silent> <leader>/ :set invhlsearch<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cabbr cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " For when you forget to sudo. Really Write the file.
    command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    vmap <C-C> "+yi<esc>
    "paste, autoindent, set back to insert mode
    imap <C-V> <esc>"+p`[v`]=`]a

    " Move lines with Ctrl-j and Ctrl-k
    nnoremap <C-k> mz:m-2<CR>`z==
    inoremap <C-j> <Esc>:m+<CR>==gi
    inoremap <C-k> <Esc>:m-2<CR>==gi
    vnoremap <C-j> :m'>+<CR>gv=`<my`>mzgv`yo`z
    nnoremap <C-j> mz:m+<CR>`z==
    vnoremap <C-k> :m'<-2<CR>gv=`>my`<mzgv`yo`z

" }

" Plugins {

    " PIV {
        let g:DisableAutoPHPFolding = 0
        let g:PIVAutoClose = 0
    " }

    " PIV {
        au VimEnter * RainbowParenthesesToggle
        au Syntax * RainbowParenthesesLoadRound
        au Syntax * RainbowParenthesesLoadSquare
        au Syntax * RainbowParenthesesLoadBraces
        let g:rbpt_colorpairs = [
                    \ ['white',       'RoyalBlue3'],
                    \ ['darkgreen',   'firebrick3'],
                    \ ['darkcyan',    'RoyalBlue3'],
                    \ ['darkred',     'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['brown',       'firebrick3'],
                    \ ['gray',        'RoyalBlue3'],
                    \ ['black',       'SeaGreen3'],
                    \ ['darkmagenta', 'DarkOrchid3'],
                    \ ['darkcyan',    'SeaGreen3'],
                    \ ['darkred',     'DarkOrchid3'],
                    \ ['red',         'firebrick3'],
                    \ ]
    " }
    " Misc {
        let g:NERDShutUp=1
        let g:NERDSpaceDelims = 1
        let b:match_ignorecase = 1
    " }

    " OmniComplete {
        " YouCompleteMe
        let g:ycm_add_preview_to_completeopt = 0
        let g:ycm_global_ycm_extra_conf = "~/.vim/ycm_extra_conf.py"
        let g:ycm_extra_conf_globlist = ['~/projects/brightcomputing/*']
        let g:ycm_collect_identifiers_from_tags_files = 1

        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " Some convenient mappings
        "inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
        inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " Automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,longest

        autocmd FileType c,cpp,objc,objcpp,python,cs let b:gotofunc="YcmCompleter GoTo"
        autocmd FileType c,cpp,objc,objcpp,python,cs let b:helpfunc="YcmCompleter GetDoc"

        hi link StructDecl Type
        hi link UnionDecl Type
        hi link ClassDecl Type
        hi link EnumDecl Type

        nmap <F2> :call Goto()<CR>
        vmap <F2> <esc>:call Goto()<CR>
        imap <F2> <esc>:call Goto()<CR>

        nmap <Leader>ff :Autoformat<CR>
        vmap <Leader>ff :Autoformat<CR>

        " Delete diff chunk
        autocmd FileType diff map dc ?^\(@@\\|Index\)<CR>d/^\(@@\\|Index\)<CR>
    " }


    " FSHere {
        let g:fsnonewfiles = 1
    " }

    " Autoformat {
        let g:formatdef_autopep8 = "'autopep8 - --range '.a:firstline.' '.a:lastline"
        let g:formatters_python = ['autopep8']
        let g:formatdef_clangformat = "'clang-format --style=file -lines='.a:firstline.':'.a:lastline"
    " }
    "

    " Xml Folding {
        let g:xml_syntax_folding=1
    " }

    " Syntastic {
        let g:syntastic_always_populate_loc_list=1
        let g:syntastic_auto_loc_list=0
        let g:syntastic_python_flake8_args='--ignore=E402,E501'
        let g:syntastic_enable_signs = 1
        let g:syntastic_enable_balloons = 0
        let g:syntastic_enable_highlighting = 0
        let g:syntastic_check_on_open = 1
        let g:syntastic_cpp_checkers=['']
    " }

    " Ctags {
        set tags=~/.vimtags

        " Disable tags highlighting (makes Vim very laggy)
        let g:easytags_dynamic_files = 2
        let g:easytags_auto_highlight = 0
        let g:easytags_syntax_keyword = 'always'
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " SnipMate {
        " Setting the author var
        let g:snips_author = 'Oleksandr Senkovych <bjsenya@gmail.com>'
    " }

    " NerdTree {
        map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        set ttymouse=xterm2
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.o', '\.d']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    " }

    " Tabularize {
        nmap <Leader>a& :Tabularize /&<CR>
        vmap <Leader>a& :Tabularize /&<CR>
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a: :Tabularize /:<CR>
        vmap <Leader>a: :Tabularize /:<CR>
        nmap <Leader>a:: :Tabularize /:\zs<CR>
        vmap <Leader>a:: :Tabularize /:\zs<CR>
        nmap <Leader>a, :Tabularize /,<CR>
        vmap <Leader>a, :Tabularize /,<CR>
        nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
    " }

    " ctrlp {
        let g:ctrlp_cmd = 'CtrlPMixed'
        let g:ctrlp_working_path_mode = 2
        " Don't index CtrlP files outside branches
        let g:ctrlp_root_markers = ['trunk', '../branches'] 
        let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.d$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$\|\.o$' }

        let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
        let g:ctrlp_extensions = ['tag']

        let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': 'find %s -type f'
        \ }

        map <leader>r :CtrlPMRU<CR>
        map <leader>t :CtrlPTag<CR>
        map <leader>b :CtrlPBuffer<CR>
    "}

    " TagBar {
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
        nmap <F8> :TagbarToggle<cr>
        vmap <F8> <esc>:TagbarToggle<cr>
        imap <F8> <esc>:TagbarToggle<cr>

        let g:tagbar_left = 1
        let g:tagbar_autofocus = 1
        let g:tagbar_compact = 1
        "Golang support for tagbar
        let g:tagbar_type_go = {
            \ 'ctagstype' : 'go',
            \ 'kinds'     : [
                \ 'p:package',
                \ 'i:imports:1',
                \ 'c:constants',
                \ 'v:variables',
                \ 't:types',
                \ 'n:interfaces',
                \ 'w:fields',
                \ 'e:embedded',
                \ 'm:methods',
                \ 'r:constructor',
                \ 'f:functions'
            \ ],
            \ 'sro' : '.',
            \ 'kind2scope' : {
                \ 't' : 'ctype',
                \ 'n' : 'ntype'
            \ },
            \ 'scope2kind' : {
                \ 'ctype' : 't',
                \ 'ntype' : 'n'
            \ },
            \ 'ctagsbin'  : 'gotags',
            \ 'ctagsargs' : '-sort -silent'
        \ }
    "}

    " Completion {
        " <TAB>: completion.
        inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif
    " }

    " UndoTree {
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
    " }

    " indent_guides {
        " Fix autocolors
        let g:indent_guides_auto_colors = 0
        autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
        autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
        let g:indent_guides_start_level = 2
        let g:indent_guides_guide_size = 1
        let g:indent_guides_enable_on_vim_startup = 1
    " }
" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=999 columns=999   " Maximize
        set guifont=Ubuntu\ Mono\ for\ Powerline\ 12,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " UnBundle {
    function! UnBundle(arg, ...)
      let bundle = vundle#config#init_bundle(a:arg, a:000)
      call filter(g:bundles, 'v:val["name_spec"] != "' . a:arg . '"')
    endfunction

    com! -nargs=+         UnBundle
    \ call UnBundle(<args>)
    " }

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    function SophHelp()
        if &buftype=="help" && match( strpart( getline("."), col(".")-1,1), "\\S")<0
            bw
        else
            if exists('b:helpfunc')
                let l:helpfunc=b:helpfunc
            else
                let l:helpfunc="help ".expand("<cword>")
            endif

            exec l:helpfunc
        endif
    endfunc

    fun! Goto()
        if exists("b:gotofunc")
            exec b:gotofunc
        else
            call feedkeys("\<C-]>")
        endif
    endfun
" }

" Finish local initializations {
    call InitializeDirectories()
" }
