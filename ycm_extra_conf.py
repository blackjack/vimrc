import os
import subprocess
import ycm_core

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-fexceptions',
    '-DNDEBUG',
    '-DUSE_CLANG_COMPLETER',
    # THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know which
    # language to use when compiling headers. So it will guess. Badly. So C++
    # headers will be compiled as C headers. You don't want that so ALWAYS specify
    # a "-std=<something>".
    # For a C project, you would set this to something like 'c99' instead of
    # 'c++11'.
    '-std=c++14',
    # ...and the same thing goes for the magic -x option which specifies the
    # language that the files to be compiled are written in. This is mostly
    # relevant for c++ headers.
    # For a C project, you would set this to 'c' instead of 'c++'.
    '-x',
    'c++',
    '-isystem',
    '../BoostParts',
    '-isystem',
    # This path will only work on OS X, but extra paths that don't exist are not
    # harmful
    '-isystem',
    '../llvm/include',
    '-isystem',
    '../llvm/tools/clang/include',
    '-I',
    '.',
    '-I',
    './ClangCompleter',
    '-isystem',
    '/usr/include',
    '-isystem',
    './tests/gmock/gtest',
    '-isystem',
    './tests/gmock/gtest/include',
    '-isystem',
    './tests/gmock',
    '-isystem',
    './tests/gmock/include',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtConcurrent',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtCore',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtDBus',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtGui',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtNetwork',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtOpenGL',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtPlatformSupport',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtPrintSupport',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtQml',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtQmlDevTools',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtQuick',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtQuickParticles',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtQuickTest',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtSql',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtTest',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtWidgets',
    '-isystem',
    '/usr/include/x86_64-linux-gnu/qt5/QtXml',
    '-isystem',
    '/usr/include/kdevplatform'
]

SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']


def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in ['.h', '.hxx', '.hpp', '.hh']


def get_git_root(filename):
    wd = os.path.dirname(filename)
    root = subprocess.check_output(['git', 'rev-parse', '--git-dir'],
                                   cwd=wd).strip()

    while True:
        basename = os.path.basename(root)
        root = os.path.dirname(root)
        if basename == ".git":
            return root


def get_compilation_database(git_root):
    try:
        compile_commands = os.path.join(git_root,
                                        "build/compile_commands.json")

        if os.path.isfile(compile_commands):
            d = os.path.dirname(compile_commands)
            return ycm_core.CompilationDatabase(d)
    except Exception:
        return None


def get_compilation_unit_filename(filename, git_root):

    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            result = basename + extension
            if os.path.exists(result):
                return result

        dirname = os.path.dirname(filename)
        while dirname.startswith(git_root):
            for _, _, files in os.walk(dirname):
                for f in files:
                    _, ext = os.path.splitext(f)
                    if ext in SOURCE_EXTENSIONS:
                        return os.path.join(dirname, f)

            dirname = os.path.dirname(dirname)

    return filename


def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))


def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForFile(filename):

    try:
        git_root = get_git_root(filename)
        filename = get_compilation_unit_filename(filename, git_root)
        database = get_compilation_database(git_root)
    except:
        database = None

    final_flags = None
    if database:
        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a "list-like" StringVec object
        compilation_info = database.GetCompilationInfoForFile(filename)
        final_flags = MakeRelativePathsInFlagsAbsolute(
            compilation_info.compiler_flags_,
            compilation_info.compiler_working_dir_)

        # NOTE: This is just for YouCompleteMe; it's highly likely that your project
        # does NOT need to remove the stdlib flag. DO NOT USE THIS IN YOUR
        # ycm_extra_conf IF YOU'RE NOT 100% YOU NEED IT.
        try:
            final_flags.remove('-stdlib=libc++')
        except ValueError:
            pass
        # raise Exception(str(final_flags))

    if not final_flags:
        relative_to = DirectoryOfThisScript()
        final_flags = MakeRelativePathsInFlagsAbsolute(flags, relative_to)

    return {
        'flags': final_flags,
        'do_cache': True
    }
