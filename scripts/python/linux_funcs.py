import os
# pwd is only available on Linux
try:
    import pwd
except:
    pwd = None
import logging
import stat

"""
Utility functions to emulate various Linux functions or commands
"""

logger = logging.getLogger(__name__)

ut_debug = False

def is_readable(file):
  """
  Attempt to open a file for reading

  Parameters
  ----------
  file: str
  The full path to the file to open

  If the file cannot be opened for read it means the file does not exist
  or the user doesn't have permission to read the file.
  The open function throws an IOError in either case

  Since the file is opened in a with block it is automatically closed
  when the with block is exited.
  """

  try:
    with open(file) as f_ptr:
      f_ptr.close()
      return True
  except IOError:
    return False

def check_user_dir(user, directory):
  """
  Check that the directory is owned by the user and has permission read,
  write, and execute for the user.

  Parameters
  ----------
  user: str
  The user's login name
  directory: str
  The full path to the directory
  """

  dir_stat = os.stat(directory)

  user_id, group_id = pwd.getpwnam(user).pw_uid, pwd.getpwnam(user).pw_gid
  dir_mode = dir_stat[stat.ST_MODE]

  # use dir_mode as mask
  # owner and has RWX
  if is_owner(user_id, dir_stat) and stat.S_IRWXU & dir_mode == stat.S_IRWXU:
    return True

  return False

def is_owner(user_id, df_stat):
  """
  Return true if the user is the owner

  Parameters
  ----------
  user_id: int - The Linux UID
  df_stat: stat - The directory or file stat object
  """
  return user_id == df_stat[stat.ST_UID]

def get_user():
  """
  Get the user's login name from their uid
  """

  return pwd.getpwuid(os.getuid()).pw_name

