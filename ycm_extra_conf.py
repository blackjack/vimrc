import sys
import os
import subprocess
from pipes import quote
from clang import cindex


###############################################################################
###############################################################################
###############################################################################


def get_default_flags():
    return [
        '-x', 'c++',
        '-std=c++11',

        '-I', '.',
        '-I', '..',
        '-isystem', '/usr/include',

        '-Wall',
        '-Wextra',
        '-Werror',
        '-Wno-long-long',
        '-Wno-variadic-macros',
        '-fexceptions',


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


def filter_flags(flags):
    return [f for f in flags if f != '-stdlib=libc++']

###############################################################################
###############################################################################
###############################################################################


SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']
HEADER_EXTENSIONS = ['.h', '.hxx', '.hpp', '.hh']


def get_extension(filename):
    return os.path.splitext(filename)[1]


def get_basename(filename):
    return os.path.splitext(filename)[0]


def is_header_file(filename):
    return get_extension(filename) in HEADER_EXTENSIONS


def is_source_file(filename):
    return get_extension(filename) in SOURCE_EXTENSIONS


def is_executable(filename):
    return os.path.isfile(filename) and os.access(filename, os.X_OK)


def make_default_flags():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    return make_relative_path_in_flags_absolute(get_default_flags(),
                                                script_dir)


def get_git_root(filename):
    try:
        wd = os.path.dirname(filename)
        root = subprocess.check_output(['git', 'rev-parse', '--git-dir'],
                                       cwd=wd).strip()

        while True:
            basename = os.path.basename(root)
            root = os.path.dirname(root)
            if basename == ".git":
                return root
    except Exception:
        return None


def get_compilation_database(git_root):
    if not git_root:
        return None

    try:
        compile_commands = os.path.join(git_root,
                                        "build/compile_commands.json")

        if os.path.isfile(compile_commands):
            directory = os.path.dirname(compile_commands)
            return cindex.CompilationDatabase.fromDirectory(directory)
    except Exception:
        return None


def find_compilation_unit_filename(filename, git_root):
    # First try the file itself
    yield filename

    # Then try to find corresponsing source file
    if is_header_file(filename):
        basename = get_basename(filename)

        for extension in SOURCE_EXTENSIONS:
            result = basename + extension
            if os.path.exists(result):
                yield result

    # Then try every source file all the way up until root of a project
    dirname = os.path.dirname(filename)
    while dirname.startswith(git_root):
        for dirpath, _, files in os.walk(dirname):
            source_files = (f for f in files if is_source_file(f))
            for f in source_files:
                yield os.path.join(dirpath, f)

            dirname = os.path.dirname(dirname)


def get_compilation_flags_from_database(filename, git_root, database):

    if not database:
        return make_default_flags()

    for filename in find_compilation_unit_filename(filename, git_root):
        compilation_info = database.getCompileCommands(filename)

        if not compilation_info:
            continue

        for item in compilation_info:
            flags = make_relative_path_in_flags_absolute(item.arguments,
                                                         item.directory)

            if flags and is_executable(flags[0]):
                flags = flags[1:]

            return flags

    return make_default_flags()


def make_relative_path_in_flags_absolute(flags, working_directory):
    if not working_directory:
        return list(flags)

    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not os.path.isabs(flag):
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


# Function called by YouCompleteMe
def FlagsForFile(filename):
    if not os.path.isabs(filename):
        filename = os.path.abspath(filename)

    git_root = get_git_root(filename)
    database = get_compilation_database(git_root)

    flags = get_compilation_flags_from_database(
        filename, git_root, database)

    flags = filter_flags(flags)

    return {
        'flags': flags,
        'do_cache': True
    }


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.stdout.write("Usage: %s [FILE]\n" % sys.argv[0])
        sys.exit(1)

    flags = [quote(f) for f in FlagsForFile(sys.argv[1])['flags']]
    print " ".join(flags)
