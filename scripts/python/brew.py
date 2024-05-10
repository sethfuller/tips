#!/usr/bin/env python3.9
import sys
import subprocess
import re

"""
Attempt to simplify the command line args of Homebrew app "brew"
Abandoned as too complex for now.
"""

def run_brew():
    cmd = ['brew']
    args = []

    sys.argv.pop(0)

    if len(sys.argv) > 0:
        for arg in sys.argv:
            args.append(arg)
            full_arg = expand_arg(arg)
            cmd.append(full_arg.get('cmd'))

    print(cmd)
    print(args)

    with subprocess.Popen(cmd, stdout = subprocess.PIPE, stderr = subprocess.PIPE, text = True) as proc:
        print('stdout', proc.stdout.read())
        print('stderr', proc.stderr.read())

def expand_arg(arg):
    full_arg = {}

    search_re = re.compile("^s$|^se$|^sea$|^sear$|^searc$|^search$")
    help_re = re.compile("^h$|^he$|^hel$|^help$")
    info_re = re.compile("^inf$|^info$")
    install_re = re.compile("^ins$|^inst$|^insta$|^instal$|^install$")
    upd_re = re.compile("^upd$|^upda$|^updat$|^update$")
    upg_re = re.compile("^upg$|^upgr$|^upgra$|^upgrad$|^upgrade$")
    uninstall_re = re.compile("^un$|^iun$|^unin$|^unins$|^uninst$|^uninsta$|^uninstal$|^uninstall$")
    list_re = re.compile("^l$|^li$|^lis$|^list$")

    if search_re.search(arg):
        full_arg['cmd'] = 'search'
    elif help_re.search(arg):
        full_arg['cmd'] = 'help'
        full_arg['min'] = 0
        full_arg['max'] = 1
    elif info_re.search(arg):
        full_arg['cmd'] = 'info'
        full_arg['min'] = 0
        full_arg['max'] = 99
    elif install_re.search(arg):
        full_arg['cmd'] = 'install'
        full_arg['min'] = 1
        full_arg['max'] = 99
    elif upd_re.search(arg):
        full_arg['cmd'] = 'update'
    elif upg_re.search(arg):
        full_arg['cmd'] = 'upgrade'
    elif uninstall_re.search(arg):
        full_arg['cmd'] = 'uninstall'
    elif list_re.search(arg):
        full_arg['cmd'] = 'list'
        full_arg['min'] = 0
        full_arg['max'] = 99
    else:
        full_arg['cmd'] = arg

    return full_arg

def main():
    print('Start brew.py')

    run_brew()

main()
