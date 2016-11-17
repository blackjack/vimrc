let b:helpfunc='GoDoc'
let b:gotofunc='GoDef'


function! SetupGoEnvironment(force)
    if exists("s:go_project_root")
        return
    endif
    let root = getcwd()
    while root != "/"
        if isdirectory(root."/src") && isdirectory(root."/pkg")
            break
        else
            let root = fnamemodify(root,':h')
        endif
    endwhile

    if root == "/"
        return
    else
        let s:go_project_root=root
        if !empty($GOPATH)
            let $GOPATH = s:go_project_root.":".$GOPATH
        else
            let $GOPATH = s:go_project_root
        endif
    endif

    if !exists("s:go_project_root")
        return
    endif
    if executable('gotags') && ( (!filereadable(s:go_project_root)) || (&force) )
        silent exec "!gotags -silent -sort $(find -L $(echo $GOPATH $GOROOT | tr ':' ' ') -name '*.go') >".s:go_project_root."/tags &"
    endif
endfunction

if executable('gotags')
    au BufWritePost *.go silent! call SetupGoEnvironment(1)
    autocmd BufNewFile,BufRead *.go call SetupGoEnvironment(0)
endif
