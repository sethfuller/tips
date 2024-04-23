#!/usr/bin/env python3

"""
date_diff.py
Get the difference between two dates or today's date
"""

import argparse
from pathlib import Path
from datetime import datetime
from datetime import timedelta
import logging
import sys

class DateDiff:
    """
    DateDiff
    Get the difference between two dates
    """

    def __init__(self):
        self.args, self.parser = create_parser()

    def calc_date_diff(self):
        """
        """
        
        dt2 = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        date1 = self.args.date1

        try:
            dt1 = datetime.strptime(date1, self.args.format)
        except ValueError as ve:
            print(f'Bad Date1: {date1} Error: {ve}')
            sys.exit(1)

        if self.args.date2:
            date2 = self.args.date2
            try:
                dt2 = datetime.strptime(date2, self.args.format)
            except ValueError as ve:
                    print(f'Bad Date2: {date2} Error: {ve}')
                    sys.exit(1)

        date_diff = dt1 - dt2
        print(f'Date 1: {dt1.strftime("%m/%d/%Y")} - Date 2: {dt2.strftime("%m/%d/%Y")} = {date_diff.days} Days')
        print(f'Date 1: {dt1} - Date 2: {dt2} = {date_diff}')

        
def create_parser():
    """
        Create the parser for all command line arguments

        Parameters
        ----------
        None

        Returns
        -------
        args   - The command line arguments argument
    """
    # Process command line arguments
    parser = argparse.ArgumentParser(description='Get Date Diff')
        # parser.add_argument('--log_level', '-l',
        #                     help='Set the log level (Default INFO)',
        #                     default='INFO')

    parser.add_argument('--date1', '-1', help='First Date', required=True)
    parser.add_argument('--date2', '-2', help='Second Date (default now)')
    parser.add_argument('--format', '-f', help='Date Format (default %m/%d/%Y)', default='%m/%d/%Y')

    args = parser.parse_args()

    return args, parser

def main():
    """
    Starts the script

    Parameters
    ----------
    None

    Returns
    ----------
    Nothing
    """

    date_diff = DateDiff()

    date_diff.calc_date_diff()

main()

