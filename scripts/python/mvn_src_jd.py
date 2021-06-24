#!/usr/bin/env python3

import argparse

class MvnSrcJavadoc:
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

    def init_cmds(self):
        dep_sources = 'dependency:sources'
        dep_javadoc = 'dependency:resolve -Dclassifier=javadoc'
        self.cmds = {
            'all': f'{dep_sources} {dep_javadoc}',
            'source': dep_sources,
            'javadoc': dep_javadoc
        }

        self.art_grp = {
            'artifact': '-DincludeArtifactIds=',
            'group': '-DincludeGroupIds=',
        }

    def validate_args(self):
        print(self.args)

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
            mvn_args = f'{self.art_grp["artifact"]}{self.args.artifact_id} {self.art_grp["group"]}{self.args.group_id}'

        mvn_cmd_line = f'mvn {mvn_cmd} {mvn_args}'
        print(mvn_cmd_line)

def main():
    mvn_src_javadoc = MvnSrcJavadoc()
    mvn_src_javadoc.run_mvn()

main()
