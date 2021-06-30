#!/usr/bin/env python3

from jproperties import Properties
import argparse

class CompareProperties:
    """
    """

    def __init__(self):
        self.config1 = Properties()
        self.config2 = Properties()
        self.init_args()

    def init_args(self):
        # Process command line arguments
        parser = argparse.ArgumentParser(description='Sort properties in a properties file')
        parser.add_argument('--log_level', '-l',
                            help='Set the log level (Default INFO)',
                           default='INFO')

        parser.add_argument('--prop1', '-1',
                            help='Properties File', required=True)
        parser.add_argument('--prop2', '-2',
                            help='Properties File', required=True)

        self.args = parser.parse_args()
        self.parser = parser


    def read_properties(self):

        with open(self.args.prop1, 'rb') as prop1_file:
            self.config1.load(prop1_file)

        with open(self.args.prop2, 'rb') as prop2_file:
            self.config2.load(prop2_file)

            print(f'Properties File: {self.args.prop1}\n')

            for key in self.config1.keys():
                value1 = self.config1.get(key)
                value2 = self.config2.get(key)
                if not value2:
                    print(f'\tNo {key} in {self.args.prop2}')
                else:
                    val1_data = value1.data
                    val2_data = value2.data
                    if val1_data != val2_data:
                        print(f'\t{key} {val1_data} != {val2_data}')

            print(f'\nProperties File: {self.args.prop2}\n')

            for key in self.config2.keys():
                value1 = self.config1.get(key)
                value2 = self.config2.get(key)
                if not value1:
                    print(f'\tNo {key} in {self.args.prop1}')

def main():
    compare_properties = CompareProperties()
    compare_properties.read_properties()

main()
