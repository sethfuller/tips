;;;;;; Bash Completion
(setq term-buffer-maximum-size (lsh 1 14))

(eval-after-load 'term
  '(progn
    (defun my-term-send-delete-word-forward () (interactive) (term-send-raw-string "\ed"))
    (defun my-term-send-delete-word-backward () (interactive) (term-send-raw-string "\e\C-h"))
    (define-key term-raw-map [C-delete] 'my-term-send-delete-word-forward)
    (define-key term-raw-map [C-backspace] 'my-term-send-delete-word-backward)
    (defun my-term-send-forward-word () (interactive) (term-send-raw-string "\ef"))
    (defun my-term-send-backward-word () (interactive) (term-send-raw-string "\eb"))
    (define-key term-raw-map [C-left] 'my-term-send-backward-word)
    (define-key term-raw-map [C-right] 'my-term-send-forward-word)
    (defun my-term-send-m-right () (interactive) (term-send-raw-string "\e[1;3C"))
    (defun my-term-send-m-left () (interactive) (term-send-raw-string "\e[1;3D"))
    (define-key term-raw-map [M-right] 'my-term-send-m-right)
    (define-key term-raw-map [M-left] 'my-term-send-m-left)
    ))

(defun my-term-mode-hook ()
  (goto-address-mode 1))
(add-hook 'term-mode-hook #'my-term-mode-hook)
;; As any usual commands as C-x o aren't working in terminal emulation mode I extended keymap with:

(unless
    (ignore-errors
      (require 'ido)
      (ido-mode 1)
      (global-set-key [?\s-d] #'ido-dired)
      (global-set-key [?\s-f] #'ido-find-file)
      t)
  (global-set-key [?\s-d] #'dired)
  (global-set-key [?\s-f] #'find-file))

(defun my--kill-this-buffer-maybe-switch-to-next ()
  "Kill current buffer. Switch to next buffer if previous command
was switching to next buffer or this command itself allowing
sequential closing of uninteresting buffers."
  (interactive)
  (let ( (cmd last-command) )
    (kill-buffer (current-buffer))
    (when (memq cmd (list 'next-buffer this-command))
      (next-buffer))))
(global-set-key [s-delete] 'my--kill-this-buffer-maybe-switch-to-next)
(defun my--backward-other-window ()
  (interactive)
  (other-window -1))
(global-set-key [s-up] #'my--backward-other-window)
(global-set-key [s-down] #'other-window)
(global-set-key [s-tab] 'other-window)
