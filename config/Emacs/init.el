;; dos to unix
;; C-x RET f undecided-unix
;; Must enable full disk access for /usr/bin/ruby to access directories
;; To do so:
;; System Preferences -> Security & Privacy -> Privacy (tab)
;; In left pane click on Full Disk Access
;; click + to add ruby
;; The /usr directory is hidden by default Command-Shift-. unhides it.

;; Turn off Package cl is deprecated warning
(setq byte-compile-warnings '(cl-functions))

;; Since Emacs 27.1 the splash screen default directory is /
(setq default-directory "~/")
(setq command-line-default-directory "~/")

;; Common Lisp Library
(require 'cl-lib)

;; (setenv "M2_HOME" "/usr/local/apache-maven-3.8.1/bin")
;; (setenv "PATH" (concat (getenv "PATH") ":/Users/sfulle176/bin"))
;; (getenv "SHELL")
; show which function the cursor is in for language modes that support it
(which-function-mode 1)

;; word movement commands move to words in camel cased text
(global-subword-mode 1)

; Highlights both parens when on one of the parens 
; (and curly braces, square brackets)
(show-paren-mode 1)

; turn on syntax color highlighting in all modes that support it
(global-font-lock-mode 1)

; show the current column number in the status bar
(column-number-mode 1)

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

;; Source: http://www.emacswiki.org/emacs-en/download/misc-cmds.el
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))

;; (add-to-list 'load-path "~/.emacs.d/archive/icicles/")
;; (require 'icicles)
;; (icy-mode 1)

;; Do not use tabs to indent
(setq-default indent-tabs-mode nil)

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

(add-to-list 'load-path "~/.emacs.d/lisp/multi-web-mode")

;; Auto select on selection of text
;; (setq mouse-drag-copy-region t) ;; only on mouse selection
(setq select-enable-primary t) ;; either keyboard or mouse

;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;; (ac-config-default)
;; (when (eq system-type 'darwin)
;;   (setq mac-right-option-modifier 'none))

(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script[^>]*>" "</script>")
                  (css-mode "<style[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

;; (require 'psvn)


;; Interactively Do Things (highly recommended, but not strictly required)
;;       (require 'ido)
;;       (ido-mode t)

(set-background-color "ivory")

(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

(require 'package)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

(package-initialize)

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

(setq exec-path-from-shell-arguments nil)
(exec-path-from-shell-initialize)
(exec-path-from-shell-copy-env "JAVA_HOME")
(exec-path-from-shell-copy-env "M2_HOME")
(exec-path-from-shell-copy-env "CM")

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;; Dired extensions
;; dired-x loading
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            ))

;; (load "helm-local-config")
(load "ido-open")
;; (require 'bm-ext)
(require 'memory-usage)
(require 'dired-sort-map)

(require 'use-package)
(use-package properties-mode
  :mode "\\.\\(properties\\|env\\)\\'")

;; BEGIN JavaScript Configuration
(require 'js2-mode)
(require 'js2-refactor)
(require 'xref-js2)

;; JavaScript indentation
(setq js-indent-level 2)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
			   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
;; END JavaScript Configuration

;; display any item that contains the chars I typed
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point nil)

(global-set-key "%" 'match-paren)

;; (global-set-key (kbd "c-x 8 r") 'revert-buffer-no-confirm)

(global-set-key (kbd "s-r") 'revert-buffer-no-confirm)

;; (global-unset-key (kbd "s-f"))
(global-set-key (kbd "s-d") 'find-dired)
(global-set-key (kbd "s-f") 'grep-find)
(global-set-key (kbd "s-m") 'manual-entry)
;; Use <cmd>-i (press both at the same time)
;; <cmd>-a (mark whole buffer) <cmd>-i (save marked region, i.e. whole buffer)
(global-set-key (kbd "C-<f9>") 'kill-ring-save)
(global-set-key (kbd "s-i") 'kill-ring-save)
(global-set-key (kbd "s-<mouse-1>") 'kill-ring-save)

(global-set-key (kbd "C-/") 'comment-region)
;; the mnemonic is C-x REALLY QUIT
;; (global-set-key (kbd "C-x r q") 'save-buffers-kill-terminal)
;; Unset normal keybinding for above
;; (global-unset-key (kbd "C-x C-c"))
;; (global-set-key (kbd "C-x C-c") 'save-buffers-kill-terminal)
;; Set suspend-frame to ignore (does nothing) (minifies frame to dock) - I never want to do this
(global-set-key (kbd "C-x C-z") `ignore)
(global-set-key (kbd "C-z") 'ignore)
(global-set-key (kbd "M-<up>") 'beginning-of-buffer) ; ESC-up arrow
(global-set-key (kbd "M-<down>") 'end-of-buffer)     ; ESC-down arrow
;; (global-set-key [?\e up] 'beginning-of-buffer) ; ESC-up arrow
;; (global-set-key [?\e down] 'end-of-buffer)     ; ESC-down arrow

; Bind compile to ESC-P
(global-set-key (kbd "M-p") 'compile)
; Bind compile to ESC-C-P
(global-set-key (kbd "M-C-p") 'compile)

(setq my-key-bindings '())

(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-x C-z")) "C-x C-z"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-z")) "C-z"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-f")) "s-f"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-m")) "s-m"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-r")) "s-r"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-<f9>")) "C-<f9>"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-i")) "s-i"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-<mouse-1>")) "s-<mouse-1>"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-/")) "C-/"))
;; M-<up> and M-<down> are activated by <Option>-<Up|Down Arrow>
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-<up>")) "M-<up> (<Option>-<Up Arrow>)"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-<down>")) "M-<down> (<Option>-<Down Arrow>)"))

(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-p")) "M-p"))
(add-to-list 'my-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-C-p")) "M-C-p"))

(setq _emacs-key-bindings '())
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-n")) "s-n"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-D")) "s-D"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-M")) "s-M"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-l")) "s-l"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-|")) "s-|"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-l")) "s-l"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-s")) "s-s"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-<wheel-down>")) "C-<wheel-down>"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-<wheel-up>")) "C-<wheel-up>"))

(add-to-list 'load-path "~/.emacs.d/lisp")

(add-to-list 'load-path "~/.emacs.d/lisp/multi-web-mode")

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

(setq company-idle-delay 0.5)
(setq company-show-numbers t)
(setq company-tooltip-limit 20)
(setq company-minimum-prefix-length 2)
(setq company-tooltip-align-annotations t)
;; invert the navigation direction if the the completion popup-isearch-match
;; is displayed on top (happens near the bottom of windows)
(setq company-tooltip-flip-when-above t)

;; (global-company-mode 1)
(add-hook 'after-init-hook 'global-company-mode)

(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; (require 'dired-sort-menu)
;; (require 'dired-sort-menu+)
;; (require 'dired+)
(require 'dired-sort-map)
;; dired+ details '('

(setq markdown-command "pandoc")

;;(load "~/.emacs.d/lisp/org_bh_config.el")
;; (load "~/.emacs.d/lisp/org_sf_config.el")
;; (load "~/.emacs.d/lisp/org_bh_todo.el")

(require 'grep)

(grep-compute-defaults)
(grep-apply-setting 'grep-command "egrep -nH -r --exclude-dir='svn' srch *")
;; (grep-apply-setting 'grep-find-command "find . -type f '!' -wholename '*/.svn/*' '!' -wholename '*/.git/*' -print0 | xargs -0 egrep -nH -e ")

(grep-apply-setting 'grep-find-command '("grep --recursive --exclude=\\*.class --exclude=\\*.grep --exclude=\\*.log --exclude=\\*~ --exclude-dir=target --exclude-dir=test --exclude-dir=dist --exclude-dir=node_modules --exclude-dir=\\.git -Hn -E  ." . 199))
;; (setq grep-find-command '("find . -type d \\( -name '.git' \\) -prune -type f -exec egrep  -nH --null -e  \\{\\} +" . 77))
;; (setq grep-find-template "find <D> <X> -type f <F> -exec egrep <C> -nH -e <R> \\{\\} +")
