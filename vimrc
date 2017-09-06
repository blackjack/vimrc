"Basic setup {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldmethod=marker nospell:
    runtime! plugin/python_setup.vim
    set nocompatible        " Must be first line
    filetype on
    filetype off
    set rtp+=~/.vim/bundle/vundle
    call vundle#rc()
    source ~/.vim/vimrc.bundles
"}

" General {
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
    set background=dark
    let g:gruvbox_contrast_dark = 'hard'
    if has ('gui')
        let g:gruvbox_italic=1
    endif
    colorscheme gruvbox
    let g:gonvim_draw_statusline = 0

    highlight ColorColumn guibg=gray20 ctermbg=235
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line
    set colorcolumn=100


    highlight iCursor guifg=white guibg=steelblue

    highlight clear SignColumn      " SignColumn should match background for
                                    " things like vim-gitgutter

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'

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
    set foldmethod=syntax
    set foldlevel=3
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

    let g:lt_location_list_toggle_map = '<leader>l'
    let g:lt_quickfix_list_toggle_map = '<leader>q'


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

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    vmap <C-C> "+yi<esc>
    "paste, autoindent, set back to insert mode
    imap <C-V> <esc>"+P`[v`]=`]a

" }

" Plugins {

    " PIV {
        let g:DisableAutoPHPFolding = 0
        let g:PIVAutoClose = 0
    " }

    " Rainbow Parentheses {
        let g:rainbow_active = 1
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
        let g:ycm_extra_conf_globlist = ['~/projects/brightcomputing/*', '~/projects/my/*']
        let g:ycm_collect_identifiers_from_tags_files = 1
        let g:ycm_complete_in_comments = 1
        let g:ycm_collect_identifiers_from_comments_and_strings = 1
        let g:ycm_always_populate_location_list = 1
        let g:ycm_disable_for_files_larger_than_kb = 1000


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

        autocmd FileType c,cpp,objc,objcpp,python,cs,rust let b:gotofunc="YcmCompleter GoTo"
        autocmd FileType c,cpp,objc,objcpp,python,cs,rust let b:goto_declaration_func="YcmCompleter GoToDeclaration"
        autocmd FileType c,cpp,objc,objcpp,python,cs,rust let b:helpfunc="YcmCompleter GetDoc"

        hi link StructDecl Type
        hi link UnionDecl Type
        hi link ClassDecl Type
        hi link EnumDecl Type

        nmap <F2> :call Goto()<CR>
        vmap <F2> <esc>:call Goto()<CR>
        imap <F2> <esc>:call Goto()<CR>

        nmap <F3> :call GotoDeclaration()<CR>
        vmap <F3> <esc>:call GotoDeclaration()<CR>
        imap <F3> <esc>:call GotoDeclaration()<CR>

        nmap <Leader>ff :Autoformat<CR>
        vmap <Leader>ff :Autoformat<CR>

        " Delete diff chunk
        autocmd FileType diff map dc ?^\(@@\\|Index\)<CR>d/^\(@@\\|Index\)<CR>
    " }


    " FSHere {
        let g:fsnonewfiles = 1
    " }

    " Autoformat {
        let g:formatdef_autopep8 = "'autopep8 - --max-line-length=100 --range '.a:firstline.' '.a:lastline"
        let g:formatters_python = ['autopep8']
        let g:formatdef_clangformat = "'clang-format --style=file -lines='.a:firstline.':'.a:lastline"

        let g:formatdef_json_tool = "'python -m json.tool'"
        let g:formatters_json = ['json_tool']

        let g:formatdef_xmllint = "'xmllint --pretty 1 -'"
        let g:formatters_xml = ['xmllint']
    " }
    "

    " Xml Folding {
        let g:xml_syntax_folding=1
    " }

    " Syntastic {
        let g:syntastic_python_flake8_args='--ignore=E402,E501,E111,E114'
        let g:syntastic_auto_loc_list = 0
        let g:syntastic_allways_populate_loc_list = 1
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
        let g:easytags_async = 1
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " NerdTree {
        map <C-e> :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.o', '\.d']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=0
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
    " }

    " fzf {
        map <M-k> :Tags<CR>
        map <C-k> :BTags<CR>

        map <leader>r :History<CR>
        map <leader>b :Buffers<CR>

        function! ProjectRoot()
            let filedir = expand('%:p:h')
            for vcs in ['.git', '.svn', '.hg']
                let dir = finddir(vcs, filedir . ';')
                let dir = substitute(dir, '\'.vcs, '', '')
                if !empty(dir)
                    return dir
                endif
            endfor
            return getcwd()
        endfunction

        let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --no-messages'
        let rg = 'rg'.
                    \' --column'.
                    \' --line-number'.
                    \' --no-heading'.
                    \' --fixed-strings'.
                    \' --ignore-case'.
                    \' --no-ignore'.
                    \' --hidden'.
                    \' --follow'.
                    \' --color "always"'.
                    \' --no-messages'
        command! -bang -nargs=* Find call fzf#vim#grep(rg.' '.shellescape(<q-args>), 1, <bang>0)
        command! -bang -nargs=* FindRoot call fzf#vim#grep(rg.' '.shellescape(<q-args>)." -- ".ProjectRoot(), 1, <bang>0)
        command! -bang FilesRoot call fzf#run(fzf#wrap(ProjectRoot(), {'dir': ProjectRoot()}, <bang>0))


        map <C-M-k> :FindRoot<CR>
        imap <C-M-k> <Esc><C-M-k>
        map <C-p> :FilesRoot<CR>
    "}

    " TagBar {
        if executable('ctags')
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
            let g:tagbar_left = 0
            let g:tagbar_autofocus = 0
            let g:tagbar_autoclose = 0
            let g:tagbar_iconchars = ['▸', '▾']
            let g:tagbar_show_visibility = 0
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
        endif
    "}

    " Completion {
        " <TAB>: completion.

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
" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=999 columns=999   " Maximize
        set guifont=Ubuntu\ Mono\ 12,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
    else
        set termguicolors
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

    fun! GotoDeclaration()
        if exists("b:goto_declaration_func")
            exec b:goto_declaration_func
        else
            call feedkeys("\<C-]>")
        endif
    endfun

    function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
        let ft=toupper(a:filetype)
        let group='textGroup'.ft
        if exists('b:current_syntax')
            let s:current_syntax=b:current_syntax
            " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
            " do nothing if b:current_syntax is defined.
            unlet b:current_syntax
        endif
        execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
        try
            execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
        catch
        endtry
        if exists('s:current_syntax')
            let b:current_syntax=s:current_syntax
        else
            unlet b:current_syntax
        endif
        execute 'syntax region textSnip'.ft.'
                    \ matchgroup='.a:textSnipHl.'
                    \ start="'.a:start.'" end="'.a:end.'"
                    \ contains=@'.group
    endfunction
" }

" Finish local initializations {
    call InitializeDirectories()
" }
