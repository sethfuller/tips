#!/usr/bin/env python3

import argparse
import sys
import general_utils as gen_utils

class MvnSrcJavadoc:
    """
    Get the source and/or javadoc for all dependencies defined in a pom.xml
    or for a specific dependency.
    """

    def __init__(self):
        self.parse_args()
        self.validate_args()
        self.init_cmds()

    def parse_args(self):
        # Process command line arguments
        parser = argparse.ArgumentParser(description='Get mvn sources/javadocs')
        parser.add_argument('--log_level', '-l',
                            help='Set the log level (Default INFO)',
                           default='INFO')

        parser.add_argument('--group_id', '-g',
                            help='Optional group ID')

        parser.add_argument('--artifact_id', '-r',
                            help='Optional artifact ID')


        parser.add_argument('--all', '-a',
                            help='Download javadoc and sources',
                            action='store_true')
        parser.add_argument('--source', '-s',
                            help='Download sources',
                            action='store_true')
        parser.add_argument('--javadoc', '-j',
                            help='Download javadoc',
                            action='store_true')

        self.args = parser.parse_args()
        self.parser = parser

    def init_cmds(self):
        dep_sources = 'dependency:sources'
        dep_javadoc = 'dependency:resolve -Dclassifier=javadoc'
        self.cmds = {
            'all': f'{dep_sources} {dep_javadoc}',
            'source': dep_sources,
            'javadoc': dep_javadoc
        }

        self.art_grp_args = {
            'artifact': '-DincludeArtifactIds=',
            'group': '-DincludeGroupIds=',
        }

    def validate_args(self):
        print(self.args)
        has_errors = False

        if not self.args.all and not self.args.source and not self.args.javadoc:
            print('Must pick one of --all --source or --javadoc')
            has_errors = True

        if has_errors:
            self.parser.print_help()
            print('Exiting')
            sys.exit(1)

    def run_mvn(self):
        mvn_cmd = ''
        mvn_args = ''

        if self.args.all:
            mvn_cmd =self.cmds['all']
        if self.args.source:
            mvn_cmd =self.cmds['source']
        if self.args.javadoc:
            mvn_cmd =self.cmds['javadoc']

        if self.args.artifact_id:
            mvn_args = f'{self.art_grp_args["artifact"]}{self.args.artifact_id} {self.art_grp_args["group"]}{self.args.group_id}'

        mvn_cmd_line = f'mvn {mvn_cmd} {mvn_args}'
        print(mvn_cmd_line)
        process = gen_utils.run_process(mvn_cmd_line)

        process_output = gen_utils.read_process_output(process, {'stdout': True, 'stderr': True})

        output_lines = process_output.get('stdout')
        print('STDOUT')
        for line in output_lines:
            print(line)

        output_lines = process_output.get('stderr')
        print('STDERR')
        for line in output_lines:
            print(line)

        gen_utils.process_ret_code(process, mvn_cmd_line)

def main():
    mvn_src_javadoc = MvnSrcJavadoc()
    mvn_src_javadoc.run_mvn()

main()
