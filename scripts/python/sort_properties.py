#!/usr/bin/env python3

from jproperties import Properties
import argparse

class SortProperties:
    """
    """

    def __init__(self):
        self.config = Properties()
        self.init_args()

    def init_args(self):
        # Process command line arguments
        parser = argparse.ArgumentParser(description='Sort properties in a properties file')
        parser.add_argument('--log_level', '-l',
                            help='Set the log level (Default INFO)',
                           default='INFO')

        parser.add_argument('--prop', '-p',
                            help='Properties File', required=True)

        self.args = parser.parse_args()
        self.parser = parser


    def read_properties(self):
        sorted_file = self.args.prop + '.sort'

        with open(self.args.prop, 'rb') as prop_file:
            self.config.load(prop_file)
            last_top_key = ''
            sorted_keys = sorted(self.config.keys())
            with open(sorted_file, 'w') as sf:
                for key in sorted_keys:
                    key_list = key.split('.')
                    top_key = key_list[0]
                    if len(key_list) > 1:
                        top_key = key_list[0] + '.' + key_list[1]

                    if last_top_key and last_top_key != top_key:
                        sf.write('\n')
                    value = self.config.get(key)
                    sf.write(f'{key}={value.data}\n')

                    last_top_key = top_key

def main():
    sort_properties = SortProperties()
    sort_properties.read_properties()

main()
