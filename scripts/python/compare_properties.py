#!/usr/bin/env python3

from jproperties import Properties
import argparse

"""
Compare the contents of two Java properties files and report the differences
"""

class CompareProperties:
    """
    Author: Seth Fuller
    Date: 09/23/2020

    This script requires python3, to install do:
    brew install python3

    This will install python3 to /usr/local/bin. Make sure that dir. is in your path.

    This script needs the module jproperties which must be installed, do:
    pip3 install jproperties

    Run as:
    /path/to/compare_properties.py --prop1 /path/to/prop1.properties --prop2 /path/to/prop2.properties

    Make this script executable with:
    chmod 755 /path/to/compare_properties.py

    When run it will automatically look for python3 on the path.

    """

    def __init__(self):
        self.config1 = Properties()
        self.config2 = Properties()
        self.init_args()

    def init_args(self):
        # Process command line arguments
        parser = argparse.ArgumentParser(description='Sort properties in a properties file')

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

            print(f'Compare Properties File: {self.args.prop1} to {self.args.prop2}\n')

            for key in self.config1.keys():
                value1 = self.config1.get(key)
                value2 = self.config2.get(key)
                if not value2:
                    print(f'\n\tNO {key} in {self.args.prop2}')
                else:
                    val1_data = value1.data
                    val2_data = value2.data
                    if val1_data != val2_data:
                        print(f'\t{key} {val1_data} != {val2_data}')

            print(f'\nKeys in Properties File: {self.args.prop2} Not in: {self.args.prop1}\n')

            for key in self.config2.keys():
                value1 = self.config1.get(key)
                value2 = self.config2.get(key)
                if not value1:
                    print(f'\tNO {key} in {self.args.prop1}')

def main():
    compare_properties = CompareProperties()
    compare_properties.read_properties()

main()
