#!/usr/bin/env python3

from os import makedirs
from os import environ
from os import popen
from os import getcwd
from os import path
from os import listdir
from os import system
import sys
import argparse
import locale;
# vary depending on your lang/locale
locale.setlocale(locale.LC_ALL, 'es_AR.UTF-8')


def _get_wrkspace_home():
    current_path=getcwd()
    
    if current_path.startswith(environ['WORKSPACE_ROOT']):
        wrk_name=current_path.split('/')[len(environ['WORKSPACE_ROOT'].split('/'))]

        return path.join(environ['WORKSPACE_ROOT'], wrk_name)
    else:
        return ''

def create_wrkspace(rootDir):
    makedirs(path.join(rootDir, 'core'))
    makedirs(path.join(rootDir, 'doc'))
    makedirs(path.join(rootDir, 'scripts'))
    f = open(path.join(rootDir, '.wrkspace'), "w")
    f.write("Now the file has more content!")
    f.close()

def go_wrkspace(go_path, current, zone):
    if current:
        wrk_home = _get_wrkspace_home()

        if wrk_home == '': raise Exception('You are not in a workspace')

        resolved_path = path.join(
            wrk_home,
            zone,
            go_path
        )

    else:
        if go_path == None or go_path == '':
            resolved_path = environ['WORKSPACE_ROOT']
        else:
            resolved_path = path.join(
                environ['WORKSPACE_ROOT'],
                go_path,
                zone,
            )
    
    if not path.exists(resolved_path): raise Exception('workspace is invalid')

    print('cd', resolved_path)

def main():
    parser = argparse.ArgumentParser(
        description='Workspace manager',
        epilog='WORKSPACE_ROOT="ABSOLUTE_PATH"'
    )

    parser.add_argument(
        '-c', '--current',
        action='store_true',
        help='used with -g to go only on current workspace'
    )
    parser.add_argument(
        '-g', '--go',
        nargs='?',
        const='',
        help='go to'
    )
    parser.add_argument(
        '-z', '--zone',
        choices=['doc', 'core', 'script'],
        default='core',
        help='doc, core or script'
    )
    
    parser.add_argument(
        '-l', '--list',
        action='store_true',
        help='list all workspaces'
    )
    
    parser.add_argument(
        '-p', '--path',
        metavar='workspace_name',
        nargs='?',
        const='',
        help='print the workspace absolute path'
    )

    parser.add_argument(
        '--create',
        metavar='workspace_name',
        help='create'
    )

    # check env
    if 'WORKSPACE_ROOT' not in environ:
        print('WORKSPACE_ROOT env is not set', file=sys.stderr)
        parser.print_help()
        sys.exit(1)
    elif not path.exists(environ['WORKSPACE_ROOT']):
        print('WORKSPACE_ROOT env must be a valid path', file=sys.stderr)
        parser.print_help()
        sys.exit(1)

    # parse args
    args = parser.parse_args()

    try:
        if args.create:
            create_wrkspace(path.join(environ['WORKSPACE_ROOT'], args.create))

            go_wrkspace(args.create, False, 'core')

            print(f"tree {path.join(environ['WORKSPACE_ROOT'], args.create)}")

            sys.exit(3)
    
        elif args.list:
            print('workspaces:')
            wrkspaces_list = listdir(environ['WORKSPACE_ROOT'])
            for wrkspace in wrkspaces_list:
                if path.isdir(path.join(environ['WORKSPACE_ROOT'], wrkspace)):
                    print(f"\t{wrkspace}", flush=True)

        elif args.path:
            if args.current: print(_get_wrkspace_home())
            else:
                if args.path == None or args.path == '': raise Exception('must suply a worspace name')
                if not path.isdir(path.join(environ['WORKSPACE_ROOT'], args.path)): raise Exception('invald workspace name')
                print(path.join(environ['WORKSPACE_ROOT'], args.path))

        elif args.go:
            go_wrkspace(args.go, args.current, args.zone)
            sys.exit(3)
        
        elif args.current:
            print(path.split(_get_wrkspace_home())[-1])

        else:
            parser.print_help()
            sys.exit(2)

        sys.exit()

    except Exception as err:
        print(err)
        sys.exit(2)

if __name__ == '__main__': main()