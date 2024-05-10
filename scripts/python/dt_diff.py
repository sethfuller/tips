#!/usr/bin/env python3

"""
dt_diff.py
Get the difference between two dates or today's date
Second version
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
        
        print(f'Year: {self.args.year} Month: {self.args.month} Day: {self.args.day}')
        dt2 = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        dt1 = check_date(self.args.month[0], self.args.day[0], self.args.year[0])
        if len(self.args.month) > 1 and len(self.args.day) > 1 and len(self.args.year) > 1:
            dt2 = check_date(self.args.month[1], self.args.day[1], self.args.year[1])

        date_diff = dt1 - dt2
        print(f'Date 1: {dt1.strftime("%m-%d-%Y")} - Date 2: {dt2.strftime("%m-%d-%Y")} = {date_diff.days} Days')

def check_date(month, day, year):
    correctDate = None
    newDate = None
    try:
        newDate = datetime(year, month, day)
        correctDate = True
    except ValueError as ve:
        print(f'Invalid Year: {year} Month: {month} Day: {day} Error: {ve}')
        sys.exit(1)
    return newDate

def check_time(hour, minute, second):
    correctTime = None
    try:
        newTime = datetime.time(hour, minute, second)
        correctTime = True
    except ValueError:
        correctTime = False
    return correctTime

def get_date_str(date_str):
    ret_date = date_str
    success = True

    if len(date_str) < 8:
        if len(date_str) == 4:
            ret_date = date_str + str(datetime.now().year)
        else:
            success = False
    elif len(date_str) > 8:
        success = False
    
    if not success:
        try:
            raise ValueError(f'Bad Date Format {"date_str"}')
        except ValueError as ve:
            print("ERROR: {ve}")
            sys.exit(1)

    return ret_date
        
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
    # parser.add_argument('--time', '-t',
    #                         help='Get time difference', action='store_true')

    # parser.add_argument('--date', '-d',
    #                         help='Get Date difference', action='store_true')
    # parser.add_argument('--datetime', '-x',
    #                         help='Get Date Time difference', action='store_true')

    parser.add_argument('--month', '-m', help='Month', nargs='+', type=int, required=True)
    parser.add_argument('--day', '-d', help='Day', nargs='+', type=int, required=True)
    parser.add_argument('--year', '-y', help='Year', nargs='+', type=int, required=True)

    parser.add_argument('--hour', '-r', help='Hour', nargs='*', type=int)
    parser.add_argument('--minute', '-n', help='Minute', nargs='*', type=int)
    parser.add_argument('--second', '-s', help='Second', nargs='*', type=int)

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

