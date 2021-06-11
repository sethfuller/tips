;; set key for agenda
(global-set-key (kbd "C-c a") 'org-agenda)

;;file to save todo items
(setq org-agenda-files (quote ("~/orgmode/todo.org")))

;;set priority range from A to C with default A
(setq org-highest-priority ?A)
(setq org-lowest-priority ?C)
(setq org-default-priority ?A)

;;set colours for priorities
(setq org-priority-faces '((?A . (:foreground "#F0DFAF" :weight bold))
                           (?B . (:foreground "LightSteelBlue"))
                           (?C . (:foreground "OliveDrab"))))

;;open agenda in current window
(setq org-agenda-window-setup (quote current-window))

;;capture todo items using C-c c t
(define-key global-map (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      '(("T" "todo" entry (file+headline "~/orgmode/todo.org" "Tasks")
         "* TODO [#A] %?")))

;; The | separates Action states from Done states
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s)" "INPROGRESS(i}" "TEST(e}" "VERIFY(v)" "|" "DONE(d)")))

(setq org-todo-keyword-faces
      '(("TODO" . org-warning) ("STARTED" . "yellow")
        ("INPROGRESS" . (:foreground "blue" :weight bold))
        ("TEST" . ("light-blue"))))
