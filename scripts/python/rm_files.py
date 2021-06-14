"""
rm_files.py
Remove files in directories specified in a YAML file
based on time and file pattern.

"""

import argparse
from pathlib import Path
from datetime import datetime
from datetime import timedelta
import logging
import sys
import re
import os
import general_utils as gen_util

# ***********************************************************************
# *
# * PROGRAM DESCRIPTION:
# *
# * This script is to remove files from directories based on file pattern
# * and specified days for expiration.
# * It reads the yaml file to get information. The fields are:
# * YAML File Format:
# *
# * -
# *
# * The dash on a line by itself starts a new record
# * dir:  specifies the path to the archive directory
# * days: specifies the days old the file must be to be deleted
# *       0 means files created today or before
# * label: If --label label_name is specified and an label: field is present
# *      only records with a matching label_name are processed.
# *      When --label is omitted, only records with the label: field are processed
# *      No label: field is the default. If --label label_name is omitted any
# *      record with an label: field will not be processed. This field is
# *      optional.
# * pattern: specifies the file pattern. It can be any pattern accepted by
# *       Linux/Windows
# * Examples
# * * - All files in the directory
# * *.* - All files with an extension
# * FILE_NAME*.txt - All files beginning with FILE_NAME, followed by any
# *                  characters, followed by .txt
# * FILE_NAME[0-9]*.txt - All files beginning with FILE_NAME, followed by the
# *                       digits 0-9, followed by any characters,
# *                       followed by .txt
# *
# ***********************************************************************
# *
# * The label field allows the user to specify a label to limit directories to
# * only those having the label. When a label is not specified directory entries
# * with labels are not processed.
# *
# * For options run rm_files.py --help|-h
# *
# * Only the option -y|--yaml_file is required with the path to a YAML file
# * with records for each directory to be cleaned.
# *
# *
# * CHANGE HISTORY:
# *
# * Date:       by:          Reason:
# *
# * 2021-06-14  Seth Fuller  Initial Version.
# ***********************************************************************

logger = logging.getLogger(__name__)

MEGA_BYTES = 1048576
DAY = 24 * 60 * 60

def remove(stat, path):
    """
    Attempt to remove a deleteable file

    Parameters
    ----------
    stat: stat object containing modification time
    path: Path  object to delete
    """

    bytes_deleted = stat.st_size
    if path.is_file():
        try:
            path.unlink()
        except FileNotFoundError:
            logger.error("{0} Not Found".format(path))
            bytes_deleted = 0

    return bytes_deleted

def is_deleteable(stat, days, args):
    """
    Determine if a file is old enough to delete

    Parameters
    ----------
    stat: stat object containing modification time
    days: int days for expiration
    args: argparse object from command line arguments
    """

    mtime = datetime.fromtimestamp(stat.st_mtime)
    now = datetime.now()

    days = int(days) - 1

    delete_time = now.replace(hour=0, minute=0, second=0, microsecond=0) + timedelta(days=-(days))

    if args.debug:
        logger.info("\t File mtime: {0} Delete Time: {1} Expired: {2}"
                    .format(mtime, delete_time, (delete_time > mtime)))

    return delete_time > mtime

def check_file_expired(file, days, args):
    """
    Check if the file is older than days old

    Parameters
    ----------
    file: Path object representing file
    days: int days for expiration
    args: argparse object from command line arguments
    """

    if file.is_file():
        stat = file.stat()

        delete_file = is_deleteable(stat, days, args)

        if args.verbose:
            logger.info('{0} Mtime: {1} Delete: {2}'
                        .format(file.name,
                                str(datetime.fromtimestamp(stat.st_mtime)),
                                str(delete_file)))
        return delete_file

    return False

def get_dir_path(dir_obj, args):
    """
    Returns a Path object for the directory or None
    if dir_obj.get('dir') empty

    Parameters
    ----------
    dir_obj: dictionary - Contains the dir, days, and pattern keys
    args: argparse object from command line arguments
    """

    drive_name = dir_obj.get('drive')

    if drive_name and not re.match('.*:', drive_name):
        drive_name = drive_name + ':'

    dir_path_name = 'XXX'
    if not dir_obj.get('dir'):
        return None

    if args.parent:
        dir_path_name = args.parent + '/' + dir_obj.get('dir')
    else:
        dir_path_name = dir_obj.get('dir')

    # List all files in directory using pathlib
    if drive_name:
        dir_path = Path(drive_name, dir_path_name)
    else:
        dir_path = Path(dir_path_name)

    return dir_path

def delete_files_in_dir(dir_obj, args):
    """
    Delete the files matching the pattern in dir_obj, that are days old

    Parameters
    ----------
    dir_obj: dictionary - Contains the dir, days, and pattern keys
    args: argparse object from command line arguments
    """
    total_dict = {}
    total_dict['delete_count'] = 0
    total_dict['mega_bytes_deleted'] = 0

    gen_util.validate_yaml(dir_obj, logger)

    days = dir_obj.get('days')

    if args.label and args.num_days:
        days = args.num_days

    dir_path = get_dir_path(dir_obj, args)

    if not dir_path:
        return total_dict

    try:
        if not dir_path.exists():
            logger.error('Dir: {0} Does not Exist'.format(dir_path))
            return total_dict
    except OSError as err:
        logger.error("OSError {0}".format(err))
        return total_dict

    delete_count = 0
    file_count = 0
    try:
        os.chdir(str(dir_path))
    except OSError as err:
        logger.error('Dir: {0} Error Accessing: {1}'.format(dir_path, err))
        return total_dict

    cwd_path = Path.cwd()

    if args.debug:
        logger.info('CWD: {0}'.format(str(cwd_path)))

#    re_pattern = glob_pattern.replace('.', '\.').replace('*', '.*')
    re_pattern = dir_obj.get('pattern').replace('*', '.*')
    ignore_cifs_pattern = '^cifs.*'

    for file in cwd_path.iterdir():

        if file.is_file() and re.match(re_pattern, file.name) \
           and not re.match(ignore_cifs_pattern, file.name):

            file_count += 1
            stat = file.stat()
            if check_file_expired(file, days, args):
                total_dict['mega_bytes_deleted'] += stat.st_size
                total_dict['delete_count'] += 1
                if args.debug:
                    logger.info("Deleting: " + file.name)
                remove(stat, file)


    logger.info('Deleted File Count: {0} of Files: {1} Matching: "{2}"'
                .format(delete_count, file_count, re_pattern))

    total_dict['mega_bytes_deleted'] = total_dict['mega_bytes_deleted'] / MEGA_BYTES

    logger.info('{0} MB deleted Dir: {1}\n'
                .format(round(total_dict['mega_bytes_deleted'], 2),
                        str(dir_path)))

    return total_dict

def main():
    """
    The main function that starts the script.
    It defines the command line arguments,
    reads the YAML file, then calls delete_dir to delete expired files,
    in the specified directory, matching the file pattern.

    delete_dir is called once for each delete record.
    """

    total_delete_count = 0
    total_mega_bytes_deleted = 0

    # Process command line arguments
    parser = argparse.ArgumentParser(description='Delete expired files')
    parser.add_argument('--log_level', '-l',
                        help='Set the log level (Default INFO)',
                        default='INFO')

    parser.add_argument('--num_days', '-n', help='number of days retention',
                        type=int)
    # This is only used for testing when you can't write to the top
    # level directory in the YAML file
    parser.add_argument('--parent', '-p',
                        help='parent directory path for archive dirs.',
                        default='')
    parser.add_argument('--yaml_file', '-y', help='yaml file', required=True)

    parser.add_argument('--label', '-e',
                        help='label name (e.g. labelX)')

    parser.add_argument('--all', '-a',
                        help='Process all directories in YAML file, including those with labels if no label specified in the options',
                        action='store_true')
    parser.add_argument('--verbose', '-v',
                        help='show removed files to the screen',
                        action='store_true')
    parser.add_argument('--debug', '-d',
                        help='debug reading yaml file', action='store_true')

    args = parser.parse_args()

    # These lines show how to set a log file for the script.
    # The script now writes to stdout
    # Setup log file
    # log_file_datestamp = datetime.now().strftime('%Y%m%d%H%M%S')
    # log_file_date = datetime.now().strftime('%Y-%m-%d')

    # log_file_name = 'rm_files' + log_file_datestamp + '.log.' + log_file_date
    # log_file_path = PurePath(args.log_dir, log_file_name)
    # print('Log: ' + str(log_file_path))
    # try:
    #     logging.basicConfig(filename = str(log_file_path))
    # except FileNotFoundError:
    #     parser.print_help()
    #     print('Log directory: ' + args.log_dir + ' Not Found')
    #     sys.exit(3)

    logger.setLevel(args.log_level)

    # Log to stdout (the console)
    handler = logging.StreamHandler(sys.stdout)
    # Log message format
    formatter = logging.Formatter("%(asctime)s %(name)s %(levelname)s %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    start = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    logger.info('Start ' + sys.argv[0] + ': ' + start)
    if args.label:
        logger.info('Label ' + args.label + ' Only')

    dir_count = 0

    dirs = gen_util.read_yaml_file(args, parser)

    if args.debug:
        logger.info('Dirs Len: {0}'.format(len(dirs)))

    for dir_obj in dirs:
        do_delete_dir = False
        if dir_count > 0 and dir_count % 20 == 0:
            proc_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            logger.info('Processed ' + str(dir_count) + ' Directories: '
                        + proc_time + ' Current: ' + dir_obj.get('dir'))
        dir_label = dir_obj.get('label')

        if args.label:
            if args.label == dir_label:
                do_delete_dir = True
            elif not dir_label:
                do_delete_dir = True
        else:
            do_delete_dir = True

        if do_delete_dir:
            dir_count += 1
            total_dict = delete_files_in_dir(dir_obj, args)
            total_delete_count += total_dict.get('delete_count')
            total_mega_bytes_deleted += total_dict.get('mega_bytes_deleted')

        logger.info(str(round(total_mega_bytes_deleted, 2))
                    + 'MB deleted Total')
        logger.info('Total Deleted Files: ' + str(total_delete_count)
                    + ' From ' + str(dir_count) + ' Directories')

        end = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        logger.info('End ' + sys.argv[0] + ': ' + end)

main()
