#!/usr/bin/env python3

import sys
import os
import subprocess
import traceback
from pathlib import Path
from pipes import quote
from clang import cindex
from distutils.spawn import find_executable


cindex.Config.set_library_path("/usr/lib/llvm-12/lib")
os.environ["DYLD_LIBRARY_PATH"] = "/usr/lib/llvm-12/lib"

###############################################################################
###############################################################################
###############################################################################


default_flags = [
    '-x', 'c++',
    '-std=c++17',

    '-I', '.',
    '-I', '..',

    '-Wall',
    '-Wextra',
    '-Werror',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-fexceptions',

    '-isystem', './tests/gmock/gtest',
    '-isystem', './tests/gmock/gtest/include',
    '-isystem', './tests/gmock',
    '-isystem', './tests/gmock/include',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtConcurrent',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtCore',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtDBus',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtGui',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtNetwork',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtOpenGL',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtPlatformSupport',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtPrintSupport',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtQml',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtQmlDevTools',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtQuick',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtQuickParticles',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtQuickTest',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtSql',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtTest',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtWidgets',
    '-isystem', '/usr/include/x86_64-linux-gnu/qt5/QtXml',

    '-isystem', '/usr/include/kdevplatform'
]


def filter_flags(flags):

    flags = ['-x', 'c++'] + flags

    def allowed(flag):
        return flag != '-stdlib=libc++' \
            and flag != '-Werror'

    return filter(allowed, flags)

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


def make_default_flags(default_flags):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    return make_relative_path_in_flags_absolute(default_flags, script_dir)


def get_git_root(filename):
    wd = os.path.dirname(filename)
    root = subprocess.check_output(['git', 'rev-parse', '--git-dir'],
                                   cwd=wd).strip()
    if not os.path.isabs(root):
        root = os.path.join(os.fsencode(wd), os.fsencode(root))

    def _go_up(current_root):
        basename = os.path.basename(current_root)
        if basename == '.git':
            sys.stderr.write("Found git root: %s \n" % os.path.dirname(current_root))
            return os.path.dirname(current_root)
        elif not current_root:
            raise Exception("Cannot find git root for file: %s" % root)

        return _go_up(Path(current_root).parent)

    p = Path(os.fsdecode(root))
    return _go_up(p)


def get_compilation_database(git_root, compilation_database_pattern):
    compile_commands = compilation_database_pattern.format(git_root=git_root)

    if os.path.isfile(compile_commands):
        directory = os.path.dirname(compile_commands)
        sys.stderr.write("Found compilation database: %s \n" % compile_commands)
        return cindex.CompilationDatabase.fromDirectory(directory)
    else:
        raise Exception(
            "Cannot open compilation database: no such file: %s"
            % compile_commands)


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

    # Then try every source file all the way up
    # recursively entering subdirs until reaching root of a project
    last_root = os.path.dirname(filename)
    current_root = os.path.dirname(filename)
    while current_root.startswith(git_root):
        pruned = False
        for root, dirs, files in os.walk(current_root):
            if not pruned:
                try:
                    # Remove the part of the tree we already searched
                    del dirs[dirs.index(os.path.basename(last_root))]
                    pruned = True
                except ValueError:
                    pass
            for f in filter(is_source_file, files):
                yield os.path.join(root, f)

        # Otherwise, pop up a level, search again
        last_root = current_root
        current_root = os.path.dirname(last_root)

    raise Exception("No appropriate flags were found for file: " % filename)


def get_compilation_flags_from_database(filename, git_root, database,
                                        default_flags=default_flags):
    for filename in find_compilation_unit_filename(filename, git_root):
        sys.stderr.write("Trying to find compilation flags for file %s \n" % filename)
        compilation_info = database.getCompileCommands(filename)

        if not compilation_info:
            continue

        for item in compilation_info:
            flags = make_relative_path_in_flags_absolute(item.arguments,
                                                         item.directory)

            if flags and is_executable(flags[0]):
                flags = flags[1:]

            sys.stderr.write("Found compilation flags for file %s\n" % filename)
            return flags

    sys.stderr.write("Could not find compilation flags for file: %s\n" % filename)
    return make_default_flags(default_flags)


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


def get_flags_for_file(filename,
                       compilation_database_pattern="{git_root}/build/compile_commands.json",
                       default_flags=default_flags,
                       filter_flags=filter_flags):

    if not os.path.isabs(filename):
        filename = os.path.abspath(filename)

    try:
        git_root = get_git_root(filename)
        default_flags = map(lambda x: x.format(git_root=git_root), default_flags)

        database = get_compilation_database(git_root,
                                            compilation_database_pattern)

        flags = get_compilation_flags_from_database(
            filename, git_root, database, default_flags)
    except Exception:
        traceback.print_exc()
        return default_flags

    return filter_flags(flags)


def Settings(**kwargs):
  if kwargs['language'] == 'cfamily':
      return {
          "flags": get_flags_for_file(kwargs['filename'])
      }
  return {}

# Searches for binaries like clang as well as clang-5.0, clang-4.0 etc


def find_clang_tool(toolname):
    executable = find_executable(toolname)
    if executable:
        return executable

    # Hopefully it's big enough
    max_tool_version = 20

    for version in xrange(max_tool_version, 1, -1):
        executable = find_executable(toolname + '-' + str(version) + '.0')
        if executable:
            return executable

    return None


def invoke_clang_tool(toolname, filename, argn, flags):
    toolname = find_clang_tool(toolname)

    cmd = [toolname]
    cmd.append(filename)
    cmd.extend(argn)
    cmd.append("--")
    cmd.extend(flags)

    return subprocess.call(cmd)


def invoke_tool(toolname, filename, argn, flags):
    if toolname.startswith('clang'):
        return invoke_clang_tool(toolname, filename, argn, flags)

    else:
        cmd = [toolname]
        cmd.append(filename)
        cmd.extend(argn)
        cmd.extend(flags)
        return subprocess.call(cmd)


if __name__ == '__main__':
    tool = None
    filename = None

    if len(sys.argv) < 2:
        sys.stdout.write('Usage: \n'
                         '{tool} [FILE] - Print flags for file\n'
                         '{tool} [TOOL] [FILE] [ARGN] - Invoke linter for file\n'
                         .format(tool=sys.argv[0]))
        sys.exit(1)
    elif len(sys.argv) == 2:
        filename = sys.argv[1]
        flags = [quote(f) for f in Settings(language='cfamily', filename=filename)['flags']]

        print(' '.join(flags))
        sys.exit(0)

    tool = sys.argv[1]
    filename = sys.argv[2]
    argn = sys.argv[3:]

    flags = [quote(f) for f in Settings(language='cfamily', filename=filename)['flags']]

    exit_code = invoke_tool(tool, filename, argn, flags)

    sys.exit(exit_code)
