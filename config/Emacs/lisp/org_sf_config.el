;; Seth Fuller
;; Date: 08-24-2020

;;;
;;; Org Mode
;;;
(add-to-list 'load-path (expand-file-name "~/Src/Editors/Emacs/org-9.3.7/lisp"))
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)

;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; From Bernt Hansen's org config file:
;; I discovered smex for IDO-completion for M-x commands after reading a
;; post of the org-mode mailing list.  I actually use M-x a lot now
;; because IDO completion is so easy.

;; Here's the smex setup I use
(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The following setting is different from the document so that you
;; can override the document org-agenda-files by setting your
;; org-agenda-files in the variable org-user-agenda-files
;;
(if (boundp 'org-user-agenda-files)
    (setq org-agenda-files org-user-agenda-files)
  (setq org-agenda-files (quote ("~/org"
                               "~/org/agenda1"
                               "~/org/agenda2"))))
;; Org-mode has the ability to show or hide the leading stars on task
;; headlines.  It's also possible to have headlines at odd levels only so
;; that the stars and heading task names line up in sublevels.

;; To make org hide leading stars use

(setq org-hide-leading-stars t)

;; To create new headings in a project file it is really convenient to
;; use =C-RET=, =C-S-RET=, =M-RET=, and =M-S-RET=.  This inserts a new headline
;; possibly with a =TODO= keyword.  With the following setting

(setq org-insert-heading-respect-content nil)

;; org inserts the heading at point for the =M-= versions and respects
;; content for the =C-= versions.  The respect content setting is
;; temporarily turned on for the =C-= versions which adds the new heading
;; after the content of the current item.  This lets you hit =C-S-RET= in
;; the middle of an entry and the new heading is added after the body of
;; the current entry but still allow you to split an entry in the middle
;; with =M-S-RET=.
;; *** Notes at the top
;; :PROPERTIES:
;; :CUSTOM_ID: NotesAtTop
;; :END:

;; I enter notes for tasks with =C-c C-z= (or just =z= in the agenda).
;; Changing tasks states also sometimes prompt for a note (e.g. moving to
;; =WAITING= prompts for a note and I enter a reason for why it is
;; waiting).  These notes are saved at the top of the task so unfolding
;; the task shows the note first.

(setq org-reverse-note-order nil)

;; *** Searching and showing results
;; :PROPERTIES:
;; :CUSTOM_ID: SearchingResults
;; :END:

;; Org-mode's searching capabilities are really effective at finding data
;; in your org files.  =C-c / /= does a regular expression search on the
;; current file and shows matching results in a collapsed view of the
;; org-file.

;; I have org-mode show the hierarchy of tasks above the matched entries
;; and also the immediately following sibling task (but not all siblings)
;; with the following settings:

(setq org-show-following-heading t)
(setq org-show-hierarchy-above t)
(setq org-show-siblings (quote ((default))))

;; This keeps the results of the search relatively compact and mitigates
;; accidental errors by cutting too much data from your org file with
;; =C-k=.  Cutting folded data (including the ...) can be really
;; dangerous since it cuts text (including following subtrees) which you
;; can't see.  For this reason I always show the following headline when
;; displaying search results.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; *** Editing and Special key handling
;; :PROPERTIES:
;; :CUSTOM_ID: SpecialKeyHandling
;; :END:

;; Org-mode allows special handling of the C-a, C-e, and C-k keys while
;; editing headlines.  I also use the setting that pastes (yanks)
;; subtrees and adjusts the levels to match the task I am pasting to.
;; See the docstring (=C-h v org-yank-adjust-subtrees=) for more details
;; on each variable and what it does.

;; I have =org-special-ctrl-a/e= set to enable easy access to the
;; beginning and end of headlines. I use =M-m= or =C-a C-a= to get to the
;; beginning of the line so the speed commands work and =C-a= to give
;; easy access to the beginning of the heading text when I need that.

(setq org-special-ctrl-a/e t)
(setq org-special-ctrl-k t)
(setq org-yank-adjusted-subtrees t)

;; ** Attachments
;; :PROPERTIES:
;; :CUSTOM_ID: Attachments
;; :END:
;; Attachments are great for getting large amounts of data related to
;; your project out of your org-mode files.  Before attachments came
;; along I was including huge blocks of SQL code in my org files to keep
;; track of changes I made to project databases.  This bloated my org
;; file sizes badly.

;; Now I can create the data in a separate file and attach it to my
;; project task so it's easily located again in the future.

;; I set up org-mode to generate unique attachment IDs with
;; =org-id-method= as follows:

(setq org-id-method (quote uuidgen))

;; Say you want to attach a file =x.sql= to your current task.  Create
;; the file data in =/tmp/x.sql= and save it.

;; Attach the file with =C-c C-a a= and enter the filename: =x.sql=.
;; This generates a unique ID for the task and adds the file in the
;; attachment directory.

;; #+begin_src org :exports src
;; ,* Attachments                                                        :ATTACH:
;;   :PROPERTIES:
;;   :Attachments: x.sql
;;   :ID:       f1d38e9a-ff70-4cc4-ab50-e8b58b2aaa7b
;;   :END:  
;; #+end_src

;; The attached file is saved in
;; =data/f1/d38e9a-ff70-4cc4-ab50-e8b58b2aaa7b/=.  Where it goes exactly
;; isn't important for me -- as long as it is saved and retrievable
;; easily.  Org-mode copies the original file =/tmp/x.sql= into the
;; appropriate attachment directory.

;; Tasks with attachments automatically get an =ATTACH= tag so you can
;; easily find tasks with attachments with a tag search.

;; To open the attachment for a task use =C-c C-a o=.  This prompts for
;; the attachment to open and =TAB= completion works here.

;; The =ID= changes for every task header when a new =ID= is generated.

;; It's possible to use named directories for attachments but I haven't
;; needed this functionality yet -- it's there if you need it.

;; I store my org-mode attachments with my org files in a subdirectory
;; =data=.  These are automatically added to my =git= repository along
;; with any other org-mode changes I've made.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Cycling Visibility
;; https://orgmode.org/manual/Global-and-local-cycling.html#Global-and-local-cycling
