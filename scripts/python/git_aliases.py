#!/usr/bin/env python3

import os
import sys
import re
import out_colors

class ReadGitAliases:
    def __init__(self):
        colors = out_colors.OutColors()
        self.RED = colors.get_fg_color("red", colors.light)
        # self.RED = colors.get_fg_high_color("red")
        self.GREEN = colors.get_fg_color("green", colors.light)
        self.MAGENTA = colors.get_fg_color("magenta")
        self.NOCOLOR = colors.get_no_color()
        self.YELLOW_BLACK = colors.get_both_color("yellow", "black")
        self.isatty = sys.stdout.isatty()
        # colors.show_256_colors()

    def read_input(self):
        print(f"\n\n{self.YELLOW_BLACK}Press Return to Continue: {self.NOCOLOR}", end='')
        read_ch = sys.stdin.read(1)

    def read_config(self):
        is_alias = False
        alias_hdr = re.compile(r"\[alias\]")
        hdr = re.compile(r"\[[a-zA-Z0-9_]+\]")
        comment = re.compile(r"#")
        count_lines = 0

        lines = 99
        if self.isatty:
            terminal_size = os.get_terminal_size()
            lines = terminal_size.lines - 1

        #        print(f"lines={terminal_size.lines} cols={terminal_size.columns}")
        home = os.getenv('HOME')
        gitconfig_file = f"{home}/.gitconfig"

        if not self.isatty:
            print(f"### [Main Tips Page]({home}/Src/Docs/tips.md)\n")
            print(f"### [Git Tips Page]({home}/Src/Docs/git_tips.md)\n")
            count_lines += 2

        print("## My Git Aliases")
        count_lines += 1

        with open(gitconfig_file, 'r') as f:
            for line in f:
                if alias_hdr.match(line):
                    is_alias = True
                elif hdr.match(line):
                    is_alias = False

                if is_alias and not alias_hdr.match(line):

                    if comment.match(line):
                        if self.isatty:
                            print(self.RED, end='')
                        print("##", end='')
                    else:
                        if self.isatty:
                            print(self.GREEN, end='')
                        print(f"> ", end='')

                    if self.isatty:
                        print(f"{line}{self.NOCOLOR}", end='')
                    else:
                        print(f"{line}", end='')
                    count_lines += 1

                    if self.isatty and count_lines % lines == 0:
                        self.read_input()
                        # input(f"\n\n{self.YELLOW_BLACK}Press Return to Continue: {self.NOCOLOR}")

        print(f"### [Git Tips Page]({home}/Src/Docs/git_tips.md)\n")
        print(f"### [Main Tips Page]({home}/Src/Docs/tips.md)\n")


def main():

    readGitAliases = ReadGitAliases()
    readGitAliases.read_config()

main()
