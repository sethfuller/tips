;; Create a list of interesting Emacs default key bindings with the functions they are bound to
;; so I don't have to remember them
;; The variable starts with underscore '_' because while it is a valid character in a
;; variable name, no other variable starts with it (in my Emacs bindings), so I can type:
;; <Ctrl>-h v<Return>_<Tab>
(setq _emacs-key-bindings '())
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-+")) "s-+|s-="))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s--")) "s--"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-n")) "s-n"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-l")) "s-l"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-|")) "s-|"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "s-l")) "s-l"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-M-\\")) "C-M-\\"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-<wheel-down>")) "C-<wheel-down>"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-<wheel-up>")) "C-<wheel-up>"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-@")) "M-@"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-&")) "M-&"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-h")) "M-h"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "M-|")) "M-|"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-x h")) "C-x h"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-x C-d")) "C-x C-d|C-x d"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-x C-q")) "C-x C-q"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-x C-r")) "C-x C-r"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-x <left>")) "C-x <left>|C-x C-<left>"))
(add-to-list '_emacs-key-bindings  (cons (lookup-key (current-global-map) (kbd "C-x <right>")) "C-x <right>|C-x C-<right>"))
