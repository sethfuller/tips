import os
import subprocess
import shlex
import sys
import re
import logging

logger = logging.getLogger(__name__)

"""
Various util functions used in other scripts
"""

ut_debug = False

def print_log(msg, logger):
    print('{0}: {1}'.format(__name__, msg))
    logger.info(msg)

def print_log_error(msg, logger):
    print('{0}: ERROR: {1}'.format(__name__, msg))
    logger.error(msg)



def run_process(command):
    """
    Run a process and return the process object
    Parameters
    ----------
    command: str
       The command to run
    """

    command_to_run = shlex.split(command)
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return process

def read_process_output(process, output_types):
    """
    Read the output from process
    Parameters
    _________
    process: subprocess process
    the process to read output from
    output_types: dictionary
    contains fields for stdout and stderr set to True (get output), or False (ignore output)

    Returns
    _______
    process_output: dictionary
    Has keys 'stdout' and 'stderr' with arrays for output
    if output is captured.
    """

    process_output = {
        'stdout': [],
        'stderr': []
    }

    if not output_types or output_types.get('stdout'):
        for line in process.stdout:
            text_line = line.decode()
            process_output['stdout'].append(text_line)

        if not output_types or output_types.get('stderr'):
            for line in process.stderr:
                text_line = line.decode()
                process_output['stderr'].append(text_line)

    process.communicate() ## Throw away any other output

    return process_output

def process_ret_code(process, command, rc_tries = 10):
    """
    Try up to rc_tries times to get return code of process.
    process.poll() returns None while process is still running

    Parameters
    _________
    process: subprocess process
    the process to read output from
    command: str
    The command that was run (print if there was an error)
    rc_tries: int
    The number of retries to get the return code (default 10)
    """

    i = 0
    while i < 10:
        ret_code = process.poll()
        if ret_code is not None:
            break
        i += 1

        if ret_code:
            print("Error running " + command)
            print("Return Code " + str(ret_code))
            sys.exit(1)

def source_file(file, cmd_args):
    """
    Emulate the bash/zsh source file_name command
    Does a source of the file running /bin/env with no predefined environment
    variables. After sourcing the file. It runs /bin/env to display all defined
    variables (only those from the file). It then reads each environment
    variable places the key and value in the os.environ dictionary, making
    the environment variables available to the script.

    Parameters
    ----------
    file: str
       The full path to the file containing the environment variable
       definitions in bash/zsh format (VAR="VALUE")
    cmd_args: str
       The list of arguments to pass along with the file name
    """
    command = shlex.split('/bin/env -i /usr/bin/bash -c "source ' + file + ' '
                          + cmd_args + ' && /bin/env"')
    process = subprocess.Popen(command, stdout=subprocess.PIPE)
    for line in process.stdout:
        (key, _, value) = line.decode().partition("=")
        value = value.strip()
        os.environ[key] = value

    process.communicate() ## Throw away any error messages

    i = 0
    while i < 10:
        ret_code = process.poll()
        if ret_code is not None:
            break
        i += 1

        if ret_code:
            print("Error sourcing " + file + " " + cmd_args)
            print("Return Code " + str(ret_code))
            sys.exit(1)

def print_environ():
    """
    Print to stdout all defined environment variables
    """

    for env in os.environ:
        print(env + ' = ' + os.environ[env])

def dump_dict(dir_dict, logger):
    logger.info('Dump_Dict - Dir: {0} Days: {1} Pattern: {2}'
                .format(dir_dict.get('dir'), dir_dict.get('days'),
                        dir_dict.get('pattern')))

def validate_yaml(dir_obj, logger):
    """
    Validate that the YAML file record contains at least the dir, days,
    and pattern fields (all other fields are optional). If any of the
    required fields are missing the script exits with code 1

    Parameters
    ----------
    dir_obj: dictionary (map)
       A dictionary of key/value pairs
    logger: logger object
       logs any errors
    """
    dir_name = dir_obj.get('dir')
    days = dir_obj.get('days')
    pattern = dir_obj.get('pattern')

    if not dir_name:
        logger.error('No directory specified')
        sys.exit(1)

    if not days:
        logger.error('No Days Specified Dir: ' + dir_name)
        sys.exit(1)
    else:
        try:
            day_int = int(days)
        except ValueError:
            logger.error('Days: "' + str(days)
                         + '" Must be an integer Dir: ' + dir_name)
            sys.exit(2)

    pattern = dir_obj.get('pattern')
    if not pattern:
        logger.error('Must specify a file pattern Dir: ' + dir_name)
        sys.exit(3)

def read_yaml_file(args, parser):
    """
    Reads a YAML file consisting of an array of key value pairs

    Parameters
    ----------
    args:   argparse object of processed command line arguments
    parser: The argparse parser object to print the automatically
            generated help message if the YAML file cannot be opened
    logger: logger object

    The format of the YAML file is (ignore the leading spaces before dash
    and subtract that number of spaces from the other fields):

    -
      dir: /path/to/archive/dir
      days: 60
      pattern: FILE_PATTERN*.*
      env: env_name (Optional)
    """

    dir_list = []
    dir_dict = {}

    print_log('Yaml file: {0}'.format(args.yaml_file), logger)
    logger.debug('Yaml file: ' + args.yaml_file)

    ym_ptr = open_yaml_file(args.yaml_file, parser)

    count = 0
    dir_dict_count = 0
    array_key = ''

    try:
        line = ym_ptr.readline().strip()
    except OSError as err:
        logger.error('Error reading line {0} Error {1} Exiting...'
                     .format(count, err))
        sys.exit(1)
    except UnicodeDecodeError as err:
        logger.error('Error reading line {0} Error {1} Exiting...'
                     .format(count, err))
        sys.exit(1)

    #  print_log('Line: {0}'.format(line), logger)
    if not line:
        print_log_error('Empty first line: {0}'.format(args.yaml_file), logger)
        
    while line:

        count += 1
        if line == '-':
            if count > 1 and len(dir_dict.keys()) > 0:
                dir_list.append(dir_dict)
                dir_dict_count += 1
                dir_dict = {}
        elif re.match('.*#+.', line):
            print_log('Yaml file comment: "{0}"  line no.: {1}'
                      .format(line, count), logger)
        elif re.match(' *- .', line):
            add_array_value(dir_dict, array_key, line, count, logger)
        else: # line != '-'
            array_key = add_key_value(dir_dict, line)

        try:
            line = ym_ptr.readline().strip()
        except OSError as err:
            logger.error('Error reading line {0} Error {1} Exiting...'
                         .format(count, err))
            sys.exit(1)
        except UnicodeDecodeError as err:
            logger.error('Error reading line {0} Error {1} Exiting...'
                         .format(count, err))
            sys.exit(1)

        print_log('{0} YAML Line: {1}'.format(count, line), logger)

    if len(dir_dict.keys()) > 0:
        dump_dict(dir_dict, logger)
        dir_list.append(dir_dict)

    print_log('Dir Dict Count: {0} Length: {1}'
              .format(dir_dict_count, len(dir_list)), logger)

    return dir_list

def open_yaml_file(yaml_file, parser):
    """
    Opens the yaml_file and returns the file pointer

    Paramaters
    ----------
    yaml_file: str - Path to the YAML file
    """
    try:
        ym_ptr = open(yaml_file)
    except EnvironmentError as e:
        parser.print_help()
        print_log_error('YAML File: {0} Not Found'.format(yaml_file), logger)
        print_log_error(os.strerror(e.errno), logger)
        sys.exit(1)

    return ym_ptr

def add_array_value(dir_dict, array_key, line, count, logger):
    """
    Adds a an array value to dir_dict dictionary

    Paramaters
    ----------
    dir_dict: dictionary - The dictionary for a directory, pattern, days to expire
    line: str - The current line
    logger: logger - The logger object
    """

    array_value = line.split('-')
    array_value.pop(0)
    value = '-'.join(array_value).strip().replace("'", '')
    print_log('Yaml Array Key: "{0}"  Value: {1} Line No.: {2}'
              .format(array_key, value, count), logger)
    if array_value:
        dir_dict[array_key].append(value)

def add_key_value(dir_dict, line):
    """
    Adds a key/value pair to dir_dict dictionary

    Paramaters
    ----------
    dir_dict: dictionary - The dictionary for a directory, pattern, days to expire
    line: str - The current line
    """

    array_key = ''
    key_value = line.split(':')
    if len(key_value) >= 2:
        key = key_value.pop(0)
        value = ':'.join(key_value).strip().replace("'", '')
        if value:
            dir_dict[key] = value
            array_key = ''
        else:
            dir_dict[key] = []
            array_key = key

    return array_key

def set_logger(log_level, handlers):

    for handler in handlers:
        logger.addHandler(handler)

def log_location():
    "Automatically log the current function details."
    import inspect
    # Get the previous frame in the stack, otherwise it would
    # be this function!!!
    func = inspect.currentframe().f_back.f_code
    location = '{0} Line: {1}:'.format(func.co_name, func.co_firstlineno)

    return location

    # Dump the message + the name of this function to the log.
    # logging.debug("%s: %s in %s:%i" % (
    #     message, 
    #     func.co_name, 
    #     func.co_filename, 
    #     func.co_firstlineno
    # ))
    
