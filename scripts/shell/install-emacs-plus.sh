#!/usr/bin/env bash

set -x
brew tap d12frosted/emacs-plus
brew install emacs-plus    [options] # install the latest release (Emacs 27)
# brew install emacs-plus@26 [options] # install Emacs 26
# brew install emacs-plus@27 [options] # install Emacs 27
# brew install emacs-plus@28 [options] # install Emacs 28

set +x
