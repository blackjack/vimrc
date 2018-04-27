call ale#Set('ycm_executable', $HOME."/.vim/ycm_extra_conf.py")

function! YcmClangCheckGetExecutable(buffer) abort
    return ale#Var(a:buffer, 'ycm_executable')
endfunction

function! YcmClangCheckGetCommand(buffer) abort

    " The extra arguments in the command are used to prevent .plist files from
    " being generated. These are only added if no build directory can be
    " detected.
    return ale#Escape(YcmClangCheckGetExecutable(a:buffer))
                \   . ' clang-check'
                \   . ' %s'
                \   . ' -analyze'
                \   . ' -extra-arg -Xclang -extra-arg -analyzer-output=text'
endfunction

call ale#linter#Define('cpp', {
            \   'name': 'ycm-clangcheck',
            \   'output_stream': 'stderr',
            \   'executable_callback': 'YcmClangCheckGetExecutable',
            \   'command_callback': 'YcmClangCheckGetCommand',
            \   'callback': 'ale#handlers#gcc#HandleGCCFormat',
            \   'lint_file': 1,
            \})
