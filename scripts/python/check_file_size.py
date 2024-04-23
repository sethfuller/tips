#!/bin/env python
## check_file_size.py
## Combine functionality of check_file_size.sh and check_size.sh
##
## Author: Seth Fuller
## Date: 12/23/2019

from pathlib import Path
import os
import sys

usage = "Usage: " + sys.argv[0] + " directory [filename] size_threshold"
directory = ''
threshold = 0
filename = ''
arg2 = None
arg3 = None

if len(sys.argv) >= 3:
    directory = sys.argv[1]
    arg2 = sys.argv[2]
    if len(sys.argv) >= 4:
        arg3 = sys.argv[3]
else:
    print(usage)
    sys.exit(1)

if arg3:
    filename = arg2
    threshold = arg3
else:
    threshold = arg2

try:
    threshold = int(threshold)
except ValueError:
    if arg3:
        print('size threshold is not an integer: ' + arg3)
    else:
        print('size threshold is not an integer: ' + arg2)
    print(usage)
    sys.exit(1)

if not filename:
    dir_path = directory
else:
    dir_path = os.path.join(directory, filename)

if not os.path.exists(dir_path):
    print(dir_path + ' does not exist')
    print(usage)
    sys.exit(1)

if not filename:
    path = (entry for entry in Path(directory).iterdir() if entry.is_file())
else:
    path = Path(directory).glob(filename + '*')

file_count = 0
for file in path:
    file_count += 1
    if threshold >= file.stat().st_size:
        sys.exit(file.name + ' Too Small')

if file_count > 0:
    print('All Good')
else:
    print("No files found")
    sys.exit(1)

sys.exit(0)
