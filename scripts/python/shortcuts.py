#!/usr/bin/env python3

import argparse
import shortcut_dict

"""
Display the shortcuts defined in shortcut_dict.py for the specified application.
Shortcuts for Chrome and IntelliJ have not been defined.
"""

class Shortcuts:
    """
    """

    def __init__(self):
        self.init_args()
        self.validate_args()

    def init_args(self):
        # Process command line arguments
        parser = argparse.ArgumentParser(description='Get mvn sources/javadocs')
        parser.add_argument('--log_level', '-l',
                            help='Set the log level (Default INFO)',
                           default='INFO')

        parser.add_argument('--mac', '-m',
                            help='show Mac shortcuts',
                            action='store_true')

        parser.add_argument('--chrome', '-c',
                            help='show Chrome shortcuts',
                            action='store_true')

        parser.add_argument('--intellij', '-i',
                            help='show Intellij shortcuts',
                            action='store_true')

        parser.add_argument('--iterm', '-t',
                            help='show iTerm2 shortcuts',
                            action='store_true')


        self.args = parser.parse_args()
        self.parser = parser

    def validate_args(self):
        print(self.args)
        has_errors = False

        if  not self.args.chrome and not self.args.mac and not self.args.intellij and not self.args.iterm:
            print('Must pick one of  --chrome or --mac or --intellij or --iterm')
            has_errors = True

        if has_errors:
            self.parser.print_help()
            print('Exiting')
            sys.exit(1)

    def display_shortcuts(self):
        if self.args.mac:
            self.print_shortcuts('Mac', shortcut_dict.shortcuts.get('mac'))

        if self.args.chrome:
            self.print_shortcuts('Chrome', shortcut_dict.shortcuts.get('chrome'))

        if self.args.intellij:
            self.print_shortcuts('Intellij', shortcut_dict.shortcuts.get('intellij'))

        if self.args.iterm:
            self.print_shortcuts('iTerm2', shortcut_dict.shortcuts.get('iterm'))

    def print_shortcuts(self, title, shortcut_list):
        print(title + ':')
        if shortcut_list:
            for shortcut in shortcut_list:
                print(f'\tKeys: {shortcut.get("keys")} {shortcut.get("description")}')
        else:
            print(f'Shortcuts not found for {title}')

        print('')

def main():
    shortcuts = Shortcuts()
    shortcuts.display_shortcuts()

main()
