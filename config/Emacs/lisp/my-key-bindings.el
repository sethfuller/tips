;; My key bindings
;; C-h v personal-keybindings (show all bindings)
;; On Mac run following commands by type <Command>-<Character>
(bind-key "s-a" 'mark-whole-buffer)
(bind-key "s-b" 'ediff-buffers)
(bind-key "s-d" 'find-dired)
(bind-key "s-e" 'ediff-directories)
(bind-key "s-f" 'grep-find)
(bind-key "s-m" 'manual-entry)
(bind-key "s-r" 'revert-buffer-no-confirm)
(bind-key "s-s" 'discover-my-major)
(bind-key "s-x" 'make-frame-command)

;; Use <Command>-i or <Command>-<Left Mouse Click>
;; Saves the highlighted text without removing it from the buffer
;; (bind-key "C-<f9>" 'kill-ring-save)
(bind-key "s-i" 'kill-ring-save)
(bind-key "s-<mouse-1>" 'kill-ring-save)

;; find-file-at-point - If the string at the current point in the buffer
;; can be interpreted as a file, go to that file
(bind-key "C-<tab>" 'find-file-at-point)
(bind-key "C-/" 'comment-region)
(bind-key "C-\\" 'uncomment-region)

;; Set suspend-frame to ignore (does nothing)
;; Normally '<Ctrl>-X <Ctrl>-z' and <Ctrl>-Z minify frame to dock - I never want to do this
(bind-key "C-x C-z" `ignore)
(bind-key "C-z" 'ignore)

;; M-<up> and M-<down> are activated by <Option|ESC>-<Up|Down Arrow>
(bind-key "M-<up>" 'beginning-of-buffer) ; ESC-up arrow
(bind-key "M-<down>" 'end-of-buffer)     ; ESC-down arrow
;; Old style key bindings
;; (bind-key [?\e up] 'beginning-of-buffer) ; ESC-up arrow
;; (bind-key [?\e down] 'end-of-buffer)     ; ESC-down arrow

; Bind compile to <Option|ESC>-P and  <Option|ESC>-C-P
(bind-key "M-p" 'compile)
(bind-key "M-C-p" 'compile)

