#!/usr/bin/env python3

import argparse

class MvnSrcJavadoc:
    def __init__(self):
        self.parse_args()
        self.validate_args()

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

    def validate_args(self):
        print(self.args)

def main():
    mvn_src_javadoc = MvnSrcJavadoc()

    
main()
