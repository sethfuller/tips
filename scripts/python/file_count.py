#!/bin/env python

import os, os.path
import sys
import argparse

def count_files(args):
    file_count = 0
    try:
        file_count = len([name for name in os.listdir(args.dir_path) if os.path.isfile(os.path.join(args.dir_path, name))])
    except PermissionError as pe:
        print(args.dir_path, 'Permissions Error', str(pe))
        parser.print_help()
        sys.exit(2)

    if file_count < args.min_count:
        sys.exit(0)

    if file_count > args.max_count:
        sys.exit(1)

    if file_count >= args.min_count and file_count <= args.max_count:
        sys.exit(9)

    print("I should not have got to this line. Something went wrong.")
    sys.exit(3)
    
parser = argparse.ArgumentParser(description='Count files in a directory')
parser.add_argument('--dir_path', '-d', help='directory path', required=True)
parser.add_argument('--max_count', '-x', help='max files', required=True, type=int)
parser.add_argument('--min_count', '-n', help='min files', required=True, type=int)
args = parser.parse_args()

if not os.path.exists(args.dir_path) or not os.path.isdir(args.dir_path):
    print(args.dir_path + ' does not exist or is not a directory')
    parser.print_help()
    sys.exit(4)

if args.min_count > args.max_count:
    print("min files must be less then max files.")
    parser.print_help()
    sys.exit(5)

count_files(args)
