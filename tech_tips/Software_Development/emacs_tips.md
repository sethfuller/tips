### [Main Tech Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)

### [Emacs Config Files](https://github.com/sethfuller/tips/tree/main/config/Emacs)

|                                                                                                        |                                                       |
|--------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| [Emacs Python Development](https://realpython.com/emacs-the-best-python-editor/)                       | [Github Company Mode](http://company-mode.github.io/) |
| [Helm](http://tuhdo.github.io/helm-intro.html)                                                         | [Helm Github](https://github.com/emacs-helm/helm)     |
| [Emacs Elisp Manual](https://ftp.gnu.org/old-gnu/Manuals/elisp-manual-20-2.5/html_node/elisp_toc.html) |                                                       |

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
    1. Open Finder
    2. Go to the Applications folder
    3. Double click on Emacs1

### Organice
    A clone of org mode that runs in the browser

> ### [Organice Github](https://github.com/200ok-ch/organice)


### [Main Tech Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)
