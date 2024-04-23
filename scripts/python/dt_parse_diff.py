#!/usr/bin/env python3

"""
date_diff.py
Get the difference between two dates or today's date
"""

import argparse
from pathlib import Path
from datetime import datetime
from datetime import timedelta
import dateparser
from dateutil.relativedelta import relativedelta
import sys

class DateDiff:
    """
    DateDiff
    Get the difference between two dates
    """

    def __init__(self):
        self.args, self.parser = create_parser()

    def format_relativedelta(self, rdelta):
        fmt = ''

        if rdelta.years != 0:
            fmt += 'Years: {} '.format(rdelta.years)

        if rdelta.months != 0:
            fmt += 'Months: {} '.format(rdelta.months)

        if rdelta.days != 0:
            fmt += 'Days: {} '.format(rdelta.days)

        fmt += ' Time {:02d}:{:02d}:{:02d}'.format(rdelta.hours,
                                                   rdelta.minutes,
                                                   rdelta.seconds)
        return fmt

    def calc_date_diff(self):
        """
        """
        dt2 = datetime.now()
        dt1 = dateparser.parse(self.args.date1)
        if not dt1:
            print('Bad Format: {}'.format(self.args.date1))
            return sys.exit(1)

        if self.args.date2:
            dt2 = dateparser.parse(self.args.date2)

        if dt1.hour == 0 and dt1.minute == 0 and dt1.second == 0:
            dt2 = dt2.replace(hour=0, minute=0, second=0, microsecond=0)
#        print('Date 1: hr {} min {} sec {}'.format(dt1.hour, dt1.minute, dt1.second))
        rdelta = relativedelta(dt1, dt2)
#        date_diff = dt1 - dt2
#        date_diff_fmt = '{}'.format(date_diff).split('.')[0]
#        print(f'Date 1: {dt1.strftime("%m/%d/%Y")} - Date 2: {dt2.strftime("%m/%d/%Y")} = {date_diff.days} Days')
        print('Date 1: {} - Date 2: {}'.format(dt1.strftime("%m-%d-%Y %H:%M:%S"),
                                               dt2.strftime("%m-%d-%Y %H:%M:%S")))
        print('Difference: {}'.format(self.format_relativedelta(rdelta)))
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

    parser.add_argument('--date1', '-1', help='First Date', required=True)
    parser.add_argument('--date2', '-2', help='Second Date (default now)')
    parser.add_argument('--format', '-f', help='Date Format (default MDY)', default='MDY')

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

