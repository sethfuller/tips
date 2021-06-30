;;^ ## Author: Seth Fuller
;;^ ## Date: 17-June-2021
;;
;; Convert a file with dos line endings <CR><LF> to unix <LF>
;; <Ctrl>-x RET f (defaults to utf-8-unix which is a good selection)
;;
;; On Mac:
;; The Emacs start script is written in ruby so:
;; Must enable full disk access for /usr/bin/ruby to access directories
;; To do so:
;; System Preferences -> Security & Privacy -> Privacy (tab)
;; In left pane click on Full Disk Access
;; click + to add ruby
;; The /usr directory is hidden by default <Command>-<Shift>-. (period) unhides it.

;; Turn off Package cl is deprecated warning
(setq byte-compile-warnings '(cl-functions))

;; Since Emacs 27.1 the splash screen default directory is /
(setq default-directory "~/")
;; Same when Emacs is run from the command line
(setq command-line-default-directory "~/")

;; Common Lisp Library
;; cl-lib is a standard library that comes with Emacs
(require 'cl-lib)

;; If the mode can figure out what function the cursor is in
;; display the function name in the mode line
(which-function-mode 1)

;; Turn on/off the toolbar at the top of the frame (window)
(tool-bar-mode 0)

;; Turn on/off scroll bar can also set to right (default) or left
;; (scroll-bar-mode 0)

;; Turn on/off menu bar
;; (menu-bar-mode 1)

;; word movement commands move to words in camel cased text
(global-subword-mode 1)

;; Highlights both parens when on one of the parens
;; (and curly braces, square brackets)
(show-paren-mode 1)

;; turn on syntax color highlighting in all modes that support it
(global-font-lock-mode 1)

;; show the current column number in the status bar
(column-number-mode 1)

;; Show size of buffer in mode line
(size-indication-mode t)

;; Set the frame title - same format as mode-line-format
;; (setq frame-title-format "%b - emacs")

;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)

;; Enable Semantic
(semantic-mode 1)

;; Org mode commands available globally
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; automatically reload files when they change on disk
;; (global-auto-revert-mode 1)

(setq markdown-command "/usr/local/bin/pandoc")

(defconst frame-default-top     10  "The 'top'  position property of a frame.")
(defconst frame-default-left    10  "The 'left' position property of a frame.")
(defconst frame-default-height  65  "The default frame height.")
(defconst frame-default-width  100  "The default frame width.")

(add-to-list 'default-frame-alist (cons 'left   frame-default-left))
(add-to-list 'default-frame-alist (cons 'top    frame-default-top))
(add-to-list 'default-frame-alist (cons 'height frame-default-height))
(add-to-list 'default-frame-alist (cons 'width  frame-default-width))

;; Do not use tabs to indent
(setq-default indent-tabs-mode nil)

;; uniquify is a standard library that comes with Emacs
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

;; Turn off bell
(setq ring-bell-function 'ignore)

(mapc
 (lambda (pair)
   (if (eq (cdr pair) 'perl-mode)
       (setcdr pair 'cperl-mode)))
 (append auto-mode-alist interpreter-mode-alist))

(add-to-list 'auto-mode-alist '("\\.jsp\\'" . mhtml-mode))

;; (add-to-list 'load-path "~/.emacs.d/lisp/multi-web-mode")

;; Auto select on selection of text
;; (setq mouse-drag-copy-region t) ;; only on mouse selection
(setq select-enable-primary t) ;; either keyboard or mouse

;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;; (ac-config-default)
;; (when (eq system-type 'darwin)
;;   (setq mac-right-option-modifier 'none))

;; multi-web-mode is available in Melpa and Melpa-stable

;; (require 'multi-web-mode)
;; (setq mweb-default-major-mode 'html-mode)
;; (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;;                   (js-mode "<script[^>]*>" "</script>")
;;                   (css-mode "<style[^>]*>" "</style>")))
;; (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;; (multi-web-global-mode 1)

;; (require 'psvn)


;; Interactively Do Things (highly recommended, but not strictly required)
;;       (require 'ido)
;;       (ido-mode t)

(set-background-color "ivory")

;; ls-lisp is a standard library that comes with Emacs
;; It provides options that MacOS ls does not
(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

;; package is a standard library that comes with Emacs
;; It provides the list-packages and package-install commands
(require 'package)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

(package-initialize)

;; Add smex to package-selected-packages
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-jedi markdown-preview-mode use-package exec-path-from-shell pandoc-mode browse-at-remote magit emmet-mode dockerfile-mode jenkinsfile-mode smex yaml-mode yaml-tomato mkdown markdown-mode tide dired-sort-menu dired-sort-menu+ dired+ json-mode jss jst jtags jvm-mode kfg kite kite-mini java-imports java-snippets javadoc-lookup autodisass-java-bytecode flymake-gjshint import-js js2-closure js2-highlight-vars js2-refactor js2-mode findr company show-css)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'load-path "~/.emacs.d/lisp")

;; Read environment variables from .zshenv, .bashrc, or .bash_profile
;; For zsh use .zshenv to define environment variables you want since this is only
;; read once on startup
;; By default PATH is loaded. Add any other variables you want access to
;; with exec-path-from-shell-copy-env as shown below
(setq exec-path-from-shell-arguments nil)
(exec-path-from-shell-initialize)
(exec-path-from-shell-copy-env "JAVA_HOME")
(exec-path-from-shell-copy-env "M2_HOME")
(exec-path-from-shell-copy-env "CM")

;; Function to toggle between opening and closing parens
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;; Use % to jump back and forth between opening and closing paren with match-paren
(global-set-key "%" 'match-paren)

;;^ ## Dired extensions
;; dired-x loading
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            ))

;; From dired-x suggest possible commands for file types
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "open")
        ("\\.mov\\'" "open")
        ("\\.pptx\\'" "open")
        ("\\.xslx\\'" "open")
        ))

;; (require 'dired-sort-menu)
;; (require 'dired-sort-menu+)
;; (require 'dired+)

;; When using sort adds option to sort by time (t), name (n), extension (x), and size (s)
;; In dired buffer type s, then one of the above character
;; In lisp/dired-sort-map.el
(require 'dired-sort-map)

;; (load "helm-local-config")
;; ido-open is a standard library that comes with Emacs
(load "ido-open")
;; (require 'bm-ext)

;; smex - helps search for recent and most frquently used commands along with ido-mode
(require 'smex)
;; smex-initialize is optional - may cause a small delay
(smex-initialize)

;; List all buffers and their memory usage
;; In lisp/memory-usage.el
(require 'memory-usage)

;; use-package Available in Melpa and Melpa-stable
(require 'use-package)
(use-package properties-mode
  :mode "\\.\\(properties\\|env\\)\\'")

;; BEGIN JavaScript Configuration
;;^ ## JavaScript Configuration
;; Improved JavaScript mode
;; All modules available in Melpa and Melpa-stable
(require 'js2-mode)
(require 'js2-refactor)
(require 'xref-js2)

;; JavaScript indentation
(setq js-indent-level 2)

;; All files ending in .js load using js2-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(add-hook 'js2-mode-hook #'js2-refactor-mode)

(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2-mode is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
			   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
;; END JavaScript Configuration

;; display any item that contains the chars I typed when visiting files
;; with <Ctrl>-x <Ctrl>-f or <Ctrl>-x <Ctrl>-f
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point nil)

;; Source: http://www.emacswiki.org/emacs-en/download/misc-cmds.el
;; Revert (reload) buffer without asking for confirmation
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm)
    (message "Reverted `%s`" (buffer-name)))

;; On Mac run following commands by type <Command>-<Character>
(global-set-key (kbd "s-a") 'mark-whole-buffer)
(global-set-key (kbd "s-b") 'ediff-buffers)
(global-set-key (kbd "s-d") 'find-dired)
(global-set-key (kbd "s-e") 'ediff-directories)
(global-set-key (kbd "s-f") 'grep-find)
(global-set-key (kbd "s-m") 'manual-entry)
(global-set-key (kbd "s-r") 'revert-buffer-no-confirm)
(global-set-key (kbd "s-x") 'make-frame-command)

;; Use <Command>-i or <Command>-<Left Mouse Click>
;; Saves the highlighted text without removing it from the buffer
;; (global-set-key (kbd "C-<f9>") 'kill-ring-save)
(global-set-key (kbd "s-i") 'kill-ring-save)
(global-set-key (kbd "s-<mouse-1>") 'kill-ring-save)

;; find-file-at-point - If the string at the current point in the buffer
;; can be interpreted as a file, go to that file
(global-set-key (kbd "C-<tab>") 'find-file-at-point)
(global-set-key (kbd "C-/") 'comment-region)
(global-set-key (kbd "C-\\") 'uncomment-region)

;; Set suspend-frame to ignore (does nothing)
;; Normally '<Ctrl>-X <Ctrl>-z' and <Ctrl>-Z minify frame to dock - I never want to do this
(global-set-key (kbd "C-x C-z") `ignore)
(global-set-key (kbd "C-z") 'ignore)

;; M-<up> and M-<down> are activated by <Option|ESC>-<Up|Down Arrow>
(global-set-key (kbd "M-<up>") 'beginning-of-buffer) ; ESC-up arrow
(global-set-key (kbd "M-<down>") 'end-of-buffer)     ; ESC-down arrow
;; Old style key bindings
;; (global-set-key [?\e up] 'beginning-of-buffer) ; ESC-up arrow
;; (global-set-key [?\e down] 'end-of-buffer)     ; ESC-down arrow

; Bind compile to <Option|ESC>-P and  <Option|ESC>-C-P
(global-set-key (kbd "M-p") 'compile)
(global-set-key (kbd "M-C-p") 'compile)

;; Create a list of my key bindings with the functions they are bound to
;; so that I can examine the list with:
;; <Ctrl>-h v<Return>my-key-bindings
;; Or Since no other variable (in my Emacs bindings) begins with 'my'
;; <Ctrl>-h v<Return>my<Tab>
(setq my-key-bindings '())

(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-x C-z")) "C-x C-z"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-z")) "C-z"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-a")) "s-a"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-a")) "s-a"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-d")) "s-d"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-e")) "s-e"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-f")) "s-f"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-i")) "s-i"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-m")) "s-m"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-r")) "s-r"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-x")) "s-x"))
;; (add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-<f9>")) "C-<f9>"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-<mouse-1>")) "s-<mouse-1>"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-/")) "C-/"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-\\")) "C-\\"))

(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-<up>")) "M-<up> (<Option>-<Up Arrow>)"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-<down>")) "M-<down> (<Option>-<Down Arrow>)"))

(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-p")) "M-p"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-C-p")) "M-C-p"))

;; Create a list of interesting Emacs default key bindings with the functions they are bound to
;; so I don't have to remember them
;; The variable starts with underscore '_' because while it is a valid character in a
;; variable name, no other variable starts with it (in my Emacs bindings), so I can type:
;; <Ctrl>-h v<Return>_<Tab>
(setq _emacs-key-bindings '())
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-+")) "s-+|s-="))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s--")) "s--"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-n")) "s-n"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-D")) "s-D"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-M")) "s-M"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-l")) "s-l"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-|")) "s-|"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-l")) "s-l"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-s")) "s-s"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-M-\\")) "C-M-\\"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-<wheel-down>")) "C-<wheel-down>"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-<wheel-up>")) "C-<wheel-up>"))

(add-to-list 'load-path "~/.emacs.d/lisp")

(add-to-list 'load-path "~/.emacs.d/lisp/multi-web-mode")

;; (defun my/python-mode-hook ()
;;   (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

;; Auto completion with Company variables
;; Wait .5 second before suggesting completions
(setq company-idle-delay 0.5)
;; Show number next to completion suggestion
(setq company-show-numbers t)
;; Limit completion suggestions to 20
(setq company-tooltip-limit 20)
;; The user must type at least 2 characters before completion suggestions are offered
(setq company-minimum-prefix-length 2)
(setq company-tooltip-align-annotations t)
;; invert the navigation direction if the the completion popup-isearch-match
;; is displayed on top (happens near the bottom of windows)
(setq company-tooltip-flip-when-above t)

;; (global-company-mode 1)
(add-hook 'after-init-hook 'global-company-mode)

;; Emmet mode allows using abbreviations to enter tags in html, sgml, css files
;; See https://docs.emmet.io/ for description of Emmet standard
;; emmet-mode available in Melpa and Melpa-stable
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; Command to run in a markdown buffer to convert it to other formats (e.g. html)
;; The output is displayed in another buffer
(setq markdown-command "pandoc")

;;(load "~/.emacs.d/lisp/org_bh_config.el")
;; (load "~/.emacs.d/lisp/org_sf_config.el")
;; (load "~/.emacs.d/lisp/org_bh_todo.el")

;; Load the grep module in order to change grep command settings
;; The grep module normally isn't loaded when init.el is read
;; grep is a standard library that comes with Emacs
(require 'grep)

(grep-compute-defaults)
(grep-apply-setting 'grep-command "egrep -nH -r --exclude-dir='svn' srch *")

;; The default for this command runs find and then execs egrep for each file
;; This definition runs recursive grep and exclude files and directories
;; I'm not interested in. The -E option allows regular expressions (like egrep) in search
;; (surrounded by single quotes). E.g.
;; 'Phrase 1|Phrase 2' (match either 'Phrase 1' 'Phrase 2'
;; . 199 places the cursor at the 199th character in the command
;; (Between '-E' and '.', e.g. '-E _ .' where '_' is the place the search term goes
(grep-apply-setting 'grep-find-command '("grep --recursive --exclude=\\*.class --exclude=\\*.grep --exclude=\\*.log --exclude=\\*~ --exclude-dir=target --exclude-dir=test --exclude-dir=dist --exclude-dir=node_modules --exclude-dir=\\.git -Hn -E  ." . 199))

;; (setq grep-find-command '("find . -type f \\( -name '.git' \\) -prune -type f -exec egrep  -nH --null -e  \\{\\} +" . 77))
;; (setq grep-find-template "find <D> <X> -type f <F> -exec egrep <C> -nH -e <R> \\{\\} +")
