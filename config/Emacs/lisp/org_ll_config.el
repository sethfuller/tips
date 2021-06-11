;; The code
;; I have heavily customized my org configuration to support the workflow I have described. Below is all of the code that enables the above workflow, as well as a few other minor things I have not described but have also found useful.

;; Todo keywords
;; This sets the todo keyword sequence and their colors.

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "STARTED(s)" "WAITING(w)"
                        "REVIEW(r)" "SUBMIT(m)"
                        "|" "DONE(d)" "DEFERRED(f)" "CANCELED(c)"))))
(setq org-todo-keyword-faces
      (quote (("TODO"      :foreground "red"          :weight bold)
              ("NEXT"      :foreground "blue"         :weight bold)
              ("STARTED"   :foreground "cyan"         :weight bold)
              ("WAITING"   :foreground "gold"         :weight bold)
              ("REVIEW"    :foreground "magenta"      :weight bold)
              ("SUBMIT"    :foreground "sea green"    :weight bold)
              ("DONE"      :foreground "forest green" :weight bold)
              ("DEFERRED"  :foreground "dark red"     :weight bold)
              ("CANCELED" :foreground "dark red"     :weight bold))))
;; Agenda
;; Basic formatting
;; This modifies agenda formatting; refer to comments for specific changes.

;; Don't display holidays that I don't follow
(customize-set-variable 'holiday-bahai-holidays nil)
(customize-set-variable 'holiday-islamic-holidays nil)

;; Following Holidays
;; (customize-set-variable 'holiday-hebrew-holidays
;;                         (quote ((holiday-hebrew-hanukkah)
;;                                 (if calendar-hebrew-all-holidays-flag
;;                                     (append (holiday-hebrew-tisha-b-av)
;;                                             (holiday-hebrew-misc))))))

;; Modify the way that entries with time specifications are displayed
(customize-set-variable 'org-agenda-use-time-grid t)
(customize-set-variable 'org-agenda-time-grid
                        (quote ((daily today require-timed)
                                #("-----------------------------------"
                                  0 35 (org-heading t))
                                (0 2400))))
(customize-set-variable 'org-agenda-current-time-string
                        #("now - - - - - - - - - - - - - - - -"
                          0 35 (org-heading t)))
;; Modify the way that deadlines are displayed
(customize-set-variable 'org-agenda-deadline-leaders
                        '("Deadline:  " "----- In %3d d.: -----"))
;; And scheduled items
(customize-set-variable 'org-agenda-scheduled-leaders
                        '(">> Scheduled: <<" "** Sched.%2dx: **"))

;; Don't warn me of an upcoming deadline if I schedule the entry
(customize-set-variable 'org-agenda-skip-deadline-prewarning-if-scheduled t)
;; Don't show scheduled entries that have been completed
(customize-set-variable 'org-agenda-skip-scheduled-if-done t)

;; Don't start with context lines from entry body
(customize-set-variable 'org-agenda-start-with-entry-text-mode nil)
;; If context lines are enabled, show up to 4 lines
(customize-set-variable 'org-agenda-entry-text-maxlines 4)

;; #+header: :tangle yes
;; #+begin_src emacs-lisp :exports none
;; Pull data for agenda from these files
;; The following setting is different from the document so that you
;; can override the document org-agenda-files by setting your
;; org-agenda-files in the variable org-user-agenda-files
;;
(if (boundp 'org-user-agenda-files)
    (setq org-agenda-files org-user-agenda-files)
  (setq org-agenda-files (quote ("~/org"
                                 "~/org/agenda.org"
                                 "~/org/agenda1"
                                 "~/org/agenda2"))))
;; #+end_src

;; Don't slow down startup when generating the agenda
(customize-set-variable 'org-agenda-inhibit-startup nil)

;; Show 14 days per page in the agenda
(customize-set-variable 'org-agenda-span 14)
;; Show upcoming deadlines for the 4 weeks
(customize-set-variable 'org-deadline-warning-days 28)
;; Start the agenda on today
(customize-set-variable 'org-agenda-start-on-weekday nil)

;; Set default priority to C
(customize-set-variable 'org-default-priority 67)
;; Color-code priorities
(customize-set-variable 'org-agenda-fontify-priorities t)
(customize-set-variable 'org-priority-faces
                        (quote ((65 :foreground "magenta" :weight bold)
                                (66 :foreground "green3")
                                (67 :foreground "orange"))))

;; Increase line spacing and highlight current line
(defun ll/org/agenda/appearance-hook ()
  (setq line-spacing 4)
  (hl-line-mode 1))
(add-hook 'org-finalize-agenda-hook #'ll/org/agenda/appearance-hook)

;; Log when tasks completed
(customize-set-variable 'org-log-done t)
;; Show clocked items for the day in the agenda
(customize-set-variable 'org-agenda-start-with-log-mode t)
Emphasis and prioritization
This implements tag-based emphasis in the agenda.

;; Color code tags
;; `focus-mode' is what I call the toggle switch for de-emphasizing tasks
(setq ll/org/agenda/focus-mode t)
(defun ll/org/agenda/focus-mode-hook ()
  (save-excursion
    (progn
      (when ll/org/agenda/focus-mode
        ;; De-emphasize all headings by making them lighter
        (ll/org/agenda/color-headers-with ":" "dark gray"))
      ;; Re-emphasize priority headings by making them black
      (ll/org/agenda/color-headers-with ":goal:" "black"))))
(add-hook 'org-finalize-agenda-hook #'ll/org/agenda/focus-mode-hook)

(defun ll/org/agenda/toggle-focus-mode ()
  "Toggle greying out of non-goal lines in the agenda."
  (interactive)
  (setq ll/org/agenda/focus-mode (not ll/org/agenda/focus-mode)))

(defun find-in-line (needle &optional beginning count)
  "Find the position of the start of NEEDLE in the current line.
  If BEGINNING is non-nil, find the beginning of NEEDLE in the current
  line. If COUNT is non-nil, find the COUNT'th occurrence from the left."
  (save-excursion
    (beginning-of-line)
    (let ((found (re-search-forward needle (point-at-eol) t count)))
      (if beginning
          (match-beginning 0)
        found))))

(setq ll/org/agenda-todo-words
      '("TODO" "GOAL" "NEXT" "STARTED" "WAITING" "REVIEW" "SUBMIT"
        "DONE" "DEFERRED" "CANCELED"))

(defun ll/org/agenda/find-todo-word-end ()
  (reduce (lambda (a b) (or a b))
          (mapcar #'find-in-line ll/org/agenda-todo-words)))

;; This comes from a stackoverflow question I forgot to record..
(defun ll/org/agenda/color-headers-with (tag col)
  "Color agenda lines matching TAG with color COL."
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward tag nil t)
    (unless (find-in-line "\\[#[A-Z]\\]")
      (let ((todo-end (or (ll/org/agenda/find-todo-word-end)
                          (point-at-bol)))
            (tags-beginning (or (find-in-line " :" t)
                                (point-at-eol))))
        (add-text-properties todo-end
                             tags-beginning
                             `(face (:foreground ,col)))))))
Refiling
This configures refiling with org-refile.

;; Refile to current file, main file, or "someday" file
;; (in that order of precedence)
(setq org-refile-targets '((nil :maxlevel . 2) ; current file
                           (org-agenda-files :maxlevel . 5)
                           ("oneday-someday.org" :maxlevel . 2)))
;; Narrow refile targets by heading > subheading
(setq org-outline-path-complete-in-steps nil)
;; Show full heading paths for refiling
(setq org-refile-use-outline-path t)
Capture
This configured capturing tasks with org-capture.

(global-set-key (kbd "C-c j") 'org-capture)
(customize-set-variable 'org-capture-templates (quote (
    ("t" "Insert a new TODO" entry
     (file+headline "~/github_sync/Notes/Main.org" "Refile")
     "** TODO %?
")
    ("n" "Insert a new NEXT" entry
     (file+headline "~/github_sync/Notes/Main.org" "Refile")
     "** NEXT %?
"))))
Clocking
This configured clocking and pomodoro timers.

(customize-set-variable 'org-clock-into-drawer "LOGBOOK")
(customize-set-variable 'org-time-clocksum-format (quote (:hours "%d"
                                                          :require-hours t
                                                          :minutes ":%02d"
                                                          :require-minutes t)))
(setq org-time-clocksum-use-fractional t)

;; Clocktable spacing appearance
(defun ll/org/clocktable-indent-string (level)
  (if (= level 1)
      ""
    (let ((str "└"))
      (while (> level 2)
        (setq level (1- level)
              str (concat str "──")))
      (concat str "─> "))))

(advice-add 'org-clocktable-indent-string
            :override #'ll/org/clocktable-indent-string)

;; Pomodoro timer upon clocking in
(customize-set-variable 'org-clock-sound
                        "/home/lukas/github_sync/notification.wav")
;; Default timer length
(customize-set-variable 'org-timer-default-timer 50) ; minutes
(add-hook 'org-clock-in-hook (lambda ()
                               ;; '(4) means just use default duration
                               (org-timer-set-timer '(4))))
Archiving
This configures where archive files are kept/named.

(customize-set-variable 'org-archive-location "archive_%s::")
Tags
This helper function makes it easier to set the tags of the current heading.

(defun ll/org/set-tags ()
  "Set the tags of the current heading, like
`org-agenda-set-tags' for outside the agenda."
  (interactive)
  (save-excursion
    (end-of-line) ;; Prevent getting prev heading if at start of curr heading
    (let* ((org-context (org-element-type (org-element-context)))
           (on-heading (equal org-context 'heading)))
      (unless on-heading
        (outline-previous-heading))
      (call-interactively 'org-set-tags))))

;; Appearance
;; These settings modify the appearance of org files.

;; Indent headings by level
(customize-set-variable 'org-startup-indented t)
;; Don't turn on truncating long lines in org mode
(customize-set-variable 'org-startup-truncated nil)
