/*
  I typically run several emacs instances at once,
  One handling IM and my timecard etc,
  and one for each project I'm currently working on.
  This way I can tailor a given instance of emacs to a given project
  as much as I want without interfering with the others,
  it simplifies buffer-switching and desktop saving etc.
  But it gets to be a PITA command-tabbing between them as they all have the same icon.
  
  This fixes that.

*/

// in src/nsfns.m, at ~L 2150, before DEFUN("ns-do-applescript"...

DEFUN ("ns-set-application-icon", Fns_set_application_icon, Sns_set_application_icon, 1, 1, 0,
       doc: /* Set the running application's icon to PATH, 
and return true, or return nil if it fails.  */)
     (Lisp_Object path)
{
  CHECK_STRING (path);
  char *s = SSDATA(path);
  NSString *ns = [[NSString stringWithUTF8String:s] stringByExpandingTildeInPath];
  NSURL *url = [NSURL fileURLWithPath:ns];
  if(!url) {
    NSLog(@"could not create url for path: %@", ns);
    return Qnil;
  }
  NSImage *img = [[NSImage alloc] initWithContentsOfURL: url];
  if(!img) {
    NSLog(@"could not create image from url: %@", url);
    return Qnil;
  }
  NSLog(@"setting application icon");
  [NSApp setApplicationIconImage:img];
  return Qt;
}

//===========================================================================

//and then above  defsubr (&Sns_do_applescript); inside the #ifdef  NS_IMPL_COCOA, export it:
defsubr (&Sns_set_application_icon);
