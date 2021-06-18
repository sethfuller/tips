### [Main Tech Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)

### [Emacs Config Files](https://github.com/sethfuller/tips/tree/main/config/Emacs)

|                                                                                                        |                                                            |
|--------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| [Emacs Python Development](https://realpython.com/emacs-the-best-python-editor/)                       | [Github Company Mode](http://company-mode.github.io/)      |
| [Helm](http://tuhdo.github.io/helm-intro.html)                                                         | [Helm Github](https://github.com/emacs-helm/helm)          |
| [Emacs Elisp Manual](https://ftp.gnu.org/old-gnu/Manuals/elisp-manual-20-2.5/html_node/elisp_toc.html) | [Multiple Configs](https://github.com/plexus/chemacs2.git) |


### Setup Multiple Emacs Copies with Different Icons
    Doing this will cause multiple copies of Emacs to run at once if you
    open both the original and new Emacs apps.

    To get alternative icons:
    1. cd ~/<some_dir> (to clone emacs-icons-project into)
    2. git clone https://github.com/emacsfodder/emacs-icons-project.git
    3. cd emacs-icons-project
    4. Examine the png files to find an icon you like

    1. mkdir -pv /Applications/Emacs1.app/Contents/Resources
    2. ln -s /Applications/Emacs.app/Contents/[IMP]* /Applications/Emacs1.app/Contents
    3. ln -s /Applications/Emacs.app/Contents/Resources/* /Applications/Emacs1.app/Contents/Resources
    4. cd /Applications/Emacs1.app/Contents/Resources
    5. rm Emacs.icns
    6. cp ~/<some_dir>/emacs-icons-project/<some_icon>.icns Emacs.icns

    The <some_icon>.icns file corresponds to the <some_icon>.png file you have chosen

    To run your new Emacs copy:
    1. Open Terminal or Iterm2 and at the prompt run:
    2. /Applications/Emacs1.app/Contents/MacOS/Emacs &

    Running the Emacs1.app from the Applications folder in Finder will only run one
    copy of Emacs, no matter how many versions you have, e.g. if you have an Emacs2.app,
    Emacs3.app, etc.) only the first run Emacs will appear. That is why you have to run
    from the command line.

#### Adding Icons for Document Types

    The emacs-icons-project also has icons for a wide variety of file types. Many of them
    you probably won't need but if you want to have different icons beside file names while
    editing do this:

    1. cp <some_dir>/emacs-icons-project/document-icons/*.icns /Applications/Emacs1.app/Contents/Resources
    2. cp /Applications/Emacs1.app/Contents/Info.plist /Applications/Emacs1.app/Contents/Info.plist.bak
    3. cp <some_dir>/emacs-icons-project/document-icons/Info.plist /Applications/Emacs1.app/Contents

    The version of Info.plist in emacs-icons-project/document-icons directory adds entries
    to map file extensions to icon files.

    You can remove files you don't need from the icns files before or after copying, if you want.
    It's a bad idea to edit the Info.plist file to remove references to the deleted icons files.
    It would be too easy to mangle the file and the entries won't cause any problems.

### Add Command Suggestions With dired-x
```elisp
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "evince" "okular")
        ("\\.\\(?:djvu\\|eps\\)\\'" "evince")
        ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" "eog")
        ("\\.\\(?:xcf\\)\\'" "gimp")
        ("\\.csv\\'" "libreoffice")
        ("\\.tex\\'" "pdflatex" "latex")
        ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|ogv\\)\\(?:\\.part\\)?\\'"
         "vlc")
        ("\\.\\(?:mp3\\|flac\\)\\'" "rhythmbox")
        ("\\.html?\\'" "firefox")
        ("\\.cue?\\'" "audacious")))
```

### Organice

    A clone of org mode that runs in the browser.

    > ### [Organice Github](https://github.com/200ok-ch/organice)

### [Main Tech Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)
