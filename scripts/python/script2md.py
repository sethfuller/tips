#!/usr/bin/env python3

import argparse
import re
import sys

"""
Turn a python, shell, JavaScript, Java or C file into Markdown making all comments
headers in the Markdown
"""

class Script2Markdown:
    def __init__(self):
        self.parse_args()
        self.init_script_info()
        self.init_exclude_md()
        self.validate_args()

    def usage(self, message, exit_val=1):
        print(f'Usage {sys.args[0]} {message}')
        self.parser.print_help()
        sys.exit(exit_val)

    def parse_args(self):
        # Process command line arguments
        parser = argparse.ArgumentParser(description='Get mvn sources/javadocs')
        parser.add_argument('--log_level', '-l',
                            help='Set the log level (Default INFO)',
                           default='INFO')

        parser.add_argument('--script', '-s',
                            help='Path to Script', required=True)

        parser.add_argument('--output', '-o',
                            help='Optional Output file (Default script.ext.md in Same Directory as Script)')

        parser.add_argument('--type', '-t',
                            help="Optional Script Type if Script Doesn't have a standard extension for it language")


        self.args = parser.parse_args()
        self.parser = parser

    def validate_args(self):
        # print(self.args)
        script_type = None
        if not self.args.type:
            script_name_parts = self.args.script.split(r'.')
            if len(script_name_parts) > 1:
                script_type = script_name_parts[len(script_name_parts) - 1]
        else:
            script_type = self.script_info[self.args.type]

        if not script_type:
            self.usage(f'No script type for {self.args.script}')

        exclude_file = script_type in self.exclude_info
        if exclude_file:
            self.usage(f'This is excluded file type Markdown', 0)

        script_info = self.script_info.get(script_type)

        if not script_info:
            self.usage(f'Invalid script type {script_type}')

        self.script_type = script_type
        self.script_info_dict = script_info

##^ ## Turn script into markdown
    def process_script(self):
        output_file = self.args.script + '.md'
        if self.args.output:
            output_file = self.args.output

        script_file = self.args.script
        file_contents = []

        comment = self.script_info_dict.get('comment')
        script_comment = f'^{comment}'
        script_comment_re = re.compile(f'{script_comment}')
        file_dict = {}

        print(script_comment_re)

        with open(script_file, 'r') as script_f:
            for line in script_f:
                comment_line_parts = line.split(comment)
                if comment_line_parts[0] == comment:
                    comment_line_parts.pop()
                    comment_line = ''.join(comment_line_parts)
                    is_new = False

                    if not file_dict.get('type'):
                        is_new = Tyue
                    elif file_dict['type'] == 'script':
                        file_contents.append(file_dict)
                        is_new = True

                    if is_new:
                        file_dict = {}
                        file_dict['type'] = 'comment'
                        file_dict['lines'] = []

                    file_dict['lines'].append(comment_line)
                else:
                    is_new = False
                    if not file_dict.get('type'):
                        is_new = True
                    elif file_dict['type'] == 'comment':
                        file_contents.append(file_dict)
                        is_new = True
                    if is_new:
                        file_dict = {}
                        file_dict['type'] = 'script'
                        file_dict['lines'] = []

                    file_dict['lines'].append(line)

            if file_dict.get('type'):
                file_contents.append(file_dict)

        print('file_contents:\n')
        print(file_contents)

        last_type = ''
        with open(output_file, 'w') as markdown_f:
            for fc_dict in file_contents:
                curr_type = fc_dict.get('type')
                if last_type == 'script':
                    markdown_f.write('```\n')

                if last_type == 'comment' or not last_type:
                    markdown_f.write(f"```{self.script_info_dict.get('code')}\n")

                markdown_f.write(''.join(fc_dict.get('lines')))
                last_type = fc_dict.get('type')

            if last_type == 'script':
                markdown_f.write('```\n')

    def init_exclude_md(self):
        self.exclude_info = ['md', 'markdown',]
        # print(self.exclude_info)

    def init_script_info(self):
        hash_comment = '##^ '
        lisp_comment = ';;^ '
        slash_comment = '//^ '

        self.script_info = {
            'py': {
                'comment': hash_comment,
                'code': 'python'
            },
            'python': {
                'comment': hash_comment,
                'code': 'python'
            },
            'sh': {
                'comment': hash_comment,
                'code': 'shell'
            },
            'zsh': {
                'comment': hash_comment,
                'code': 'zsh'
            },
            'bash': {
                'comment': hash_comment,
                'code': 'bash'
            },
            'js': {
                'comment': slash_comment,
                'code': 'js'
            },
            'javascript': {
                'comment': slash_comment,
                'code': 'javascript'
            },
            'java': {
                'comment': slash_comment,
                'code': 'java'
            },
            'c': {
                'comment': slash_comment,
                'code': 'c'
            },
            'h': {
                'comment': slash_comment,
                'code': 'c'
            },
            'cpp': {
                'comment': slash_comment,
                'code': 'c++'
            },
            'hpp': {
                'comment': slash_comment,
                'code': 'c++'
            },
            'el': {
                'comment': lisp_comment,
                'code': 'lisp'
            },

        }
        # print(self.script_info)

def main():
    script_2_md = Script2Markdown()
    script_2_md.process_script()
    
main()
