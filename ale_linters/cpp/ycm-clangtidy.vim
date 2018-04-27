call ale#Set('ycm_executable', $HOME."/.vim/ycm_extra_conf.py")
call ale#Set('cpp_ycm_clangtidy_checks', ['*'])

function! YcmClangTidyGetExecutable(buffer) abort
    return ale#Var(a:buffer, 'ycm_executable')
endfunction

function! YcmClangTidyGetCommand(buffer) abort
    let l:checks = join(ale#Var(a:buffer, 'cpp_clangtidy_checks'), ',')

    return ale#Escape(YcmClangTidyGetExecutable(a:buffer))
                \   . ' clang-tidy'
                \   . ' %s'
                \   . (!empty(l:checks) ? ' -checks=' . ale#Escape(l:checks) : '')
endfunction

call ale#linter#Define('cpp', {
            \   'name': 'ycm-clangtidy',
            \   'output_stream': 'stdout',
            \   'executable_callback': 'YcmClangTidyGetExecutable',
            \   'command_callback': 'YcmClangTidyGetCommand',
            \   'callback': 'ale#handlers#gcc#HandleGCCFormat',
            \   'lint_file': 1,
            \})

