;; Author: Ryan Rix

;; Created: 2019-11-26 Tue 04:20

;; PLANNING Work on the Emacs workflow system

;; NEXT Automatically clock in to :flow: t children using org-goto-first-child
;; When looking at the style of work I do, my work falls in to four broad categories: interrupts, projects, idle actions, and schedulings. The core of my task management is built around Org mode1, built in to Emacs, with hooks integrating it in to my desktop environments and other parts of my workflow.

;; Most of my org-mode workflow is built on top of Bernt Hansen's wonderful org-mode literate configuration

(provide 'cce-org)

;; Loading Org-mode

;; Org-mode is a huge piece of kit, and is incredibly powerful. We have a lot of directions that we can take its use, and curating that is a very important aspect to making sure that we can stay productive with it. I load org-plus-contrib to get the version of org-mode from Org ELPA, which is more up to date and shiny.

;; We should use Org-mode for any file that is .org or .org_archive.

(install-pkgs '(org-plus-contrib))
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" . org-mode))

;; Org is wonderfully modular, allowing you to only pull in what you need, and to ignore the rest of it. We curate a small list of modules to include, matching the pieces of kit that Org is going to interact with.

;; org-id 3: Gives each entry a GUID which can be referenced easily with org-id-get, org-id-find, org-id-goto etc functions.
;; org-habit 4: Habits are a wonderful new part of Org mode which allows you to create repeating events that have a certain elasticity to them, as well as view the history of them easily in agendas.
;; org-protocol 6: Intercepts certain types of emacsclient calls to seamlessly org-capture. I use this to feed browser tabs in to Org-mode.
;; org-w3m 7: Allows you to yank HTML from w3m and paste it in to org, in org format.
;; org-bbdb 8: Another link integration module, linking to BBDB entries in Org-mode.

(setq org-modules '(org-id
                    org-habit
                    org-protocol
                    org-eww
                    org-bbdb
                    org-choose
                    org-panel
                    org-tempo
                    org-depend))

;; After setting org-modules we load in Org-mode itself.

(require 'org-element)
(require 'org)
(require 'org-compat)
(require 'org-checklist)

;; Global Key Bindings

;; Let's set up a bunch of keybindings; we want the most common tasks that we run to be easily accessible, and on a good easy to grab keybinding. A lot of these are inspired by Bernt's keybindings.

;; Wherever I am, I can hit C-c l to store a link to that thing (assuming its a mode that supports Org-mode links), or I can hit C-c c to enter Org capture, which I'll get in to in a bit

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") 'org-capture)

(define-key org-mode-map (kbd "M-o") 'ace-link-org)

(define-key org-mode-map (kbd "<f9> t") 'bh/insert-inactive-timestamp)
(define-key org-mode-map (kbd "<f2> t") 'bh/insert-inactive-timestamp)
(define-key org-mode-map (kbd "<f9> T") 'bh/toggle-insert-inactive-timestamp)

;; bh Helper Functions
;; Bernt Hansen defines a bunch of neat helper functions for working with his project workflow, which I copy and fill in a bit on below.

;; Switch a task from NEXT to INPROGRESS when clocking in. Skips capture tasks, projects, and subprojects.

(setq org-clock-in-switch-to-state 'bh/clock-in-to-inprogress)
(defun bh/clock-in-to-inprogress (kw)
  "Switch a task from NEXT to INPROGRESS when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"

  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "NEXT"))
           (bh/is-task-p))
      "INPROGRESS")
     ((and (member (org-get-todo-state) (list "NEXT"))
           (bh/is-project-p))
      "INPROGRESS"))))

;; Helper function which finds a project task for a given task.

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

;; Clock in a task given an ID; this is a generic helper; bh/clock-in-organization-task-as-default doesn't use this because it doesn't have way to mark it as the default task.

(require 'org-id)
(setq org-id-method 'uuidgen)
(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

;; This function shows my Org agenda, it should probably be put in to hydra-workflow

(defun show-org-agenda ()
  (interactive)
  (if org-agenda-sticky
      (switch-to-buffer "*Org Agenda( )*")
    (switch-to-buffer "*Org Agenda*"))
  (delete-other-windows))

;; Appearance and Behavior Tweaks
;; Turn on org-indent by default, this makes text indent to the level of its org-mode heading. Looks great paired with the hidden leading stars below.

(require 'org-indent)
(setq org-startup-indented t)
(diminish 'org-indent-mode)

;; Hide leading stars; only draw the right-most star in a heading.

(setq org-hide-leading-stars nil)

;; Show an empty line between trees if it is there.

(setq org-cycle-separator-lines 2)

;; Archiving tasks; We don't change their state to DONE if we archive them, since that's not necessarily true.

(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")

;; Don't let me close Projecst that have incomplete tasks.

(setq org-enforce-todo-dependencies t)

;; Formatting new entries – Make intelligent decisions based on what things around me are doing.

(setq org-blank-before-new-entry '((heading)
                                   (plain-list-item . auto)))

;; Insert headings where I ask for it, rather than at the end of the subtree.

(setq org-insert-heading-respect-content nil)

;; Store notes at the need of a file or entry.

(setq org-reverse-note-order nil)

;; Reveal lots of entries nearby when unhiding an entry.

(setq org-show-following-heading t)
(setq org-show-hierarchy-above t)
(setq org-show-siblings '((default)))

;; Be smart about killing and moving; if there is a closed fold, act on the entire fold.

(setq org-special-ctrl-a/e t)
(setq org-special-ctrl-k t)
(setq org-yank-adjusted-subtrees t)

;; Warn 30 days away from a deadline.

(setq org-deadline-warning-days 30)

;; Export org tables to CSV.

(setq org-table-export-default-format "orgtbl-to-csv")

;; Open things in current frame.

(setq org-link-frame-setup '((vm . vm-visit-folder)
                             (gnus . org-gnus-no-new-news)
                             (file . find-file)))
(setq org-src-window-setup 'current-window)

;; Log the time a task is completed.

(setq org-log-done 'time)

;; Log in to the drawer.

(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)

;; position the habit graph on the agenda to the right of the default

(setq org-habit-graph-column 50)

;; Show the habit table at 06:00; if it gets hidden during the day, we will have it unhidden in the morning.

(run-at-time "06:00" 86400 '(lambda () (setq org-habit-show-habits t)))

;; Shove a newline at the end of our documents. FIXME MOVEME

(setq require-final-newline t)

;; If a date is incomplete, assume it is in the future.

(setq org-read-date-prefer-future 'time)

;; Use '-' as the bullet list exclusively.

(setq org-list-demote-modify-bullet '(("+" . "-")
                                      ("*" . "-")
                                      ("1." . "-")
                                      ("1)" . "-")
                                      ("A)" . "-")
                                      ("B)" . "-")
                                      ("a)" . "-")
                                      ("b)" . "-")
                                      ("A." . "-")
                                      ("B." . "-")
                                      ("a." . "-")
                                      ("b." . "-")))

;; Do not persist filters across agenda views.

(setq org-agenda-persistent-filter nil)

;; Use the built-in compose-mail to send mails.

(setq org-link-mailto-program '(compose-mail "%a" "%s"))

;; Some hooks for message-mode, enable limited Org-mode bindings in non-org buffers.

(add-hook 'message-mode-hook 'turn-on-auto-fill 'append)
(add-hook 'message-mode-hook 'orgtbl-mode 'append)
(add-hook 'message-mode-hook 'turn-on-flyspell 'append)
(add-hook 'message-mode-hook
          '(lambda () (setq fill-column 72))
          'append)

;; Enable bbdb in mail if we have it.

(add-hook 'mail-setup-hook 'bbdb-mail-aliases)

;; Disable keys in org-mode

;; C-c [
;; C-c ]
;; C-c ;
;; C-c C-x C-q cancelling the clock (we never want this)

(add-hook 'org-mode-hook
          '(lambda ()
             (org-defkey org-mode-map "\C-c[" 'undefined)
             (org-defkey org-mode-map "\C-c]" 'undefined)
             (org-defkey org-mode-map "\C-c;" 'undefined)
             (org-defkey org-mode-map "\C-c\C-x\C-q" 'undefined))
          'append)

;; Follow links on return.

(setq org-return-follows-link t)

;; Fold these lists too:

;; hi
;; hi
;; hi
;; hi
;; hi
(setq org-cycle-include-plain-lists t)

;; Fontify code in codeblocks

(setq org-src-fontify-natively t)

;; When opening a file, start with all the outlines folded.

(setq org-startup-folded t)

;; Overwrite the current window with the agenda

(setq org-agenda-window-setup 'current-window)

;; Delete IDs when we clone an Entry. IDs should always be unique.

(setq org-clone-delete-id t)

;; Don't allow edits in folded space.

(setq org-catch-invisible-edits 'error)

;; Always use UTF-8 everywhere.

(setq org-export-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-charset-priority 'unicode)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; Format clock summary as x:xx

(setq org-time-clocksum-format
      '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

;; Always make sure we have an ID in our Org entries

(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

;; Wrap strings with these emphases.

(setq org-emphasis-alist '(("*" bold "<b>" "</b>")
                           ("/" italic "<i>" "</i>")
                           ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
                           ("=" org-code "<code>" "</code>" verbatim)
                           ("~" org-verbatim "<code>" "</code>" verbatim)))

;; Save buffers every hour

(run-at-time "00:59" 3600 'org-save-all-org-buffers)
When I edit org source blocks with C-c ' it reformats them with a leading space. Don't do that, please.

(setq org-edit-src-content-indentation 0)
(setq org-table-use-standard-references 'from)
(setq org-file-apps '((auto-mode . emacs)
                      ("\\.mm\\'" . system)
                      ("\\.x?html?\\'" . system)
                      ("\\.pdf\\'" . system)))

;; Flowing with Hydra

;; One of the things I struggle the most with in my day is figuring out simple things like:

;; what should I work on now?
;; where did this heading go?
;; In the past I answered these questions separately, but the more I think about how I use Org-mode the more I'd like all of this to end up on the same prefix, a sort of 'workflow' prefix. I service this via Hydra. I am overriding C-x o which is used for the default window management system, since I'm not using that in favor of a Hydra head that does it.

(setq rrix/email-task '(kusanagi "23b51dee-064b-47bf-8031-71b55c242517"
                        tres-ebow "23b51dee-064b-47bf-8031-71b55c242517"
                        solitary-living "23b51dee-064b-47bf-8031-71b55c242517"
                        penguin "23b51dee-064b-47bf-8031-71b55c242517"
                        work "2a38a282-5a39-44f3-8250-03ee333276bd"))

(setq rrix/lunch-task "a8e2e2c6-bef7-4efb-805d-bc3c4486c89b"
      rrix/break-task "83c92aea-7a6e-4a1a-9593-e2081aad983e"
      rrix/prep-task "9d6279b8-c921-46e7-8ee4-b4d367dca1e0")

(setq rrix/morning-flow "9d6279b8-c921-46e7-8ee4-b4d367dca1e0")

(defun cce/org-goto-agenda-heading (&optional prompt)
  (interactive)
  (let* ((location (org-refile-get-location (or prompt "Goto")))
         (marker (car (last location))))
    (switch-to-buffer (marker-buffer marker))
    (goto-char marker)
    (org-show-context)
    (current-buffer)))

(defun rrix/clock-in-email-task ()
  (interactive)
  (bh/clock-in-task-by-id
   (plist-get rrix/email-task (intern (system-name))))
  (gnus))

(defun rrix/clock-in-lunch-task ()
  (interactive)
  (bh/clock-in-task-by-id rrix/lunch-task)
  (org-clock-goto)
  (org-add-note))

(defun rrix/clock-in-break-task ()
  (interactive)
  (bh/clock-in-task-by-id rrix/break-task)
  (org-agenda nil "i"))

(defun rrix/clock-morning-prep ()
  (interactive)
  (bh/clock-in-task-by-id rrix/morning-flow)
  (org-clock-goto)
  (bh/narrow-to-subtree))

(defun cce/note-to-clock ()
  "Add a note to the currently clocked task."
  (interactive)
  (save-window-excursion
    (org-clock-goto)
    (org-add-note)))

(defhydra hydra-workflow (global-map "C-c o" :hint nil)
  "
Searching ----------> Do stuff --------> Do Stuff 2 -------> Workflow ---------------> Nar/Wid ------------------>
_i_: In-file headings   _d_: Clock in        _c_: Capture          _m_: Prep meeting notes     _n_: Narrow to Subtree
_h_: All headings       _e_: Email           _<_: Last Task        _M_: Mail meeting notes     _w_: Widen
_a_: Select an Agenda   _l_: Lunch           _j_: Jump Clock       _B_: BBDB search            _r_: Narrow to region
_g_: Go to active clock _b_: Break           _P_: Insert BBDB      _c_: Capture                _t_: Show TODO Entries
                      _k_: Morning prep    _z_: Capture Note                               _s_: *scratch*
                      _o_: Clock out                                                     _S_: Org Scratch
"
  ("<" bh/clock-in-last-task)
  ("a" org-agenda :exit t)
  ("B" bbdb)
  ("b" rrix/clock-in-break-task)
  ("c" org-capture)
  ("d" bh/punch-in)
  ("e" rrix/clock-in-email-task)
  ("g" org-clock-goto)
  ("h" cce/org-goto-agenda-heading)
  ("i" org-goto)
  ("j" (progn
         (interactive)
         (setq current-prefix-arg '(4))
         (call-interactively 'org-clock-in)))
  ("k" rrix/clock-morning-prep)
  ("l" rrix/clock-in-lunch-task)
  ("M" bh/mail-subtree)
  ("m" bh/prepare-meeting-notes)
  ("n" bh/narrow-to-subtree)
  ("o" bh/punch-out)
  ("P" bh/phone-call)
  ("r" narrow-to-region)
  ("S" bh/make-org-scratch)
  ("s" bh/switch-to-scratch)
  ("t" bh/org-todo)
  ("w" bh/widen)
  ("z" cce/note-to-clock))

(evil-leader/set-key "o" 'hydra-workflow/body)

(global-set-key (kbd "<XF86Mail>") #'hydra-workflow/body)
(global-set-key (kbd "<XF86Calculator>") #'cce/note-to-clock)
(global-set-key (kbd "<XF86Explorer>") #'org-capture)
This starts your day; When called, you clock in to your Organization task and this becomes your default task, which you can hit by calling org-clock-in and hitting d.

(defun bh/punch-in (arg)
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      (let* ((marker (org-get-at-bol 'org-hd-marker))
             (tags (org-with-point-at marker (org-get-tags-at))))
        (if (and (eq arg 4) tags)
            (org-agenda-clock-in '(16))
          (bh/clock-in-organization-task-as-default)))
    (save-restriction
      (widen)
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
          (org-clock-in '(16))
        (bh/clock-in-organization-task-as-default)))))

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find organization-task-id 'marker)
    (org-clock-in '(16))))

;; This ends your day; When you clock out, it removes any restrictions, clocks you out.

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

;; Task Tracking

;; Org-mode allows you to tag entries, and define those tags as a set of steps. I have sets of tags for each of my Data Types, one set for tasks and interupts, one set for projects, one set for schedulings, one set for idle actions. In each data type, I define these in depth, but the basic idea is that I should be able to model a workflow with these states and know exactly what I can be working on at any given time.

;; full-state-workflow.png

;; That graph is mostly a joke, I promise. Let's codify these states, and use fast selection. The states are fully documented below in Data Types.

(setq org-todo-keywords '((sequence "NEXT(n)" "PLANNING(P)" "INPROGRESS(i)" "WAITING(w)" "|" "ICEBOX(x)" "DONE(d)")
                          (sequence "PHONE(p)" "MEETING(m)" "|" "CANCELLED(c)")
                          (sequence "IDLE(a)")))
(setq org-use-fast-todo-selection t)

;; We live in a pretty, colorful future, let's do that with our org-todo-keywords.

(setq org-todo-keyword-faces
      '(("NEXT" :foreground "blue" :weight bold)
        ("INPROGRESS" :foreground "burlywood" :weight bold)
        ("DONE" :foreground "forest green" :weight bold)
        ("WAITING" :foreground "orange" :weight bold)
        ("ICEBOX" :foreground "orange" :weight normal)
        ("CANCELLED" :foreground "forest green" :weight bold)
        ("MEETING" :foreground "yellow" :weight bold)
        ("PHONE" :foreground "yellow" :weight bold)
        ("IDLE" :foreground "magenta" :weight bold)))

;; Data Types

;; Tasks

;; The basic unit of "thing to do".

;; Tasks can be grouped in to TAGged categories by the type of task they are, and can also be given locational context with tags prefixed with @, for example @APARTMENT for tasks I need to be at home to do.

;; States
;; WAITING tasks are things that are waiting on the completion of other tasks
;; NEXT tasks are things that I can work on right now; they are not blocked by anything and can be picked up
;; INPROGRESS tasks that are currently being worked on; this is a shortcut for "NEXT and have had clocks applied", as a way to easily eyeball them.
;; DONE tasks that are complete and ready for archiving
;; ICEBOX tasks that are on ice until future work deems it necessary. These, in general, could also be archived in a non-DONE state but this makes it easier to get the full picture of a project.
;; tasks-workflow.png

;; Interrupts
;; Interrupts are external asks that require an immediate or near-immediate context switch. A server catching on fire, a code review request. These tasks should be catelogged easily and it should be easy to reference where my time, as a whole, is being spent.

;; Capturing and working with interupts should be the easiest part of my workflow; Org-mode's capture templates 9 come a long way to make this happen, they just need the final 5% to make them truly first-class in my workflow by defining capture templates to ease recording my most common interrupts.
;; States
;; The states array for Interrupts are the same as for Tasks.

;; Projects
;; Projects are long-term groupings of tasks towards a certain goal; bring up a datacenter, build and fly a new RC plane from scratch, travel the world, raise a family. Projects don't have to specify a number of tasks, or their size, or anything along those lines. A grouping of tasks to reach a certain goal is a project.I will categorize and contextualize hundreds of tasks across tens of projects, because that is naturally how I best work; my long term goals are many and varied, and my system should catelog those as well as it catelogs the code reviews that I need to complete before the end of the day.

;; States
;; PLANNING Projects that I have sketched out but not begun; I will often go and greenfield something and then forget about it; this signals that state where I have not actually begun work on something, and may well have not even finished brainstorming it.
;; NEXT Projects that have been planned but are not yet in progress.
;; INPROGRESS Projects that have been worked on.
;; ICEBOX Projects that I am putting on ice for the time being.
;; projects-workflow.png

;; You'll notice that there is no DONE state for a project. I don't actually think that's a useful thing for Projects for a few reasons. First, I don't think a project is ever truly done, simply that it's been on ice or abandoned. Done is needlessly final. Second, when a project isn't being worked on any more, it shares no context with the projects around it, unlink Task states. Projects live on their own, and can die on their own.

;; Schedulings
;; Schedulings are, in the broadest sense, things that are pre-planned, but one off. Meetings, events, habits, all of these should be exposed in my Agendas to properly contextualize the amount of work I'll be able to complete outside of them. These can exist in many places – some may be in my Work calendar stored on Google's servers, some may be from RSS feeds, some may come from static iCal files such as Meetup or Eventbrite provide.

;; States
;; States all converge to DONE here, and there is not a true workflow, really. These tasks exist to track time, not necessarily project cadence, and thus don't have a cadence of their own really.

;; MEETING In person meetings, whether they are one-offs or recurring.
;; PHONE Phone calls, yeah, you know.
;; DONE Objects that we no longer need to track.
;; CANCELED Shit that didn't happen.
;; The problem that I have yet to tackle with Scheduling objects comes to recurring situations. A weekly phone call, a daily standup; there will be notes and state that should be exposed easily with these events. Org mode has the ability to tack notes on to a clocking period, but it doesn't allow for a full org-outline, simple plain text only, which makes this a subpar situation IMO. I think that the proper solution may be to datestamp recurring Scheduling entries and write some Elisp which finds recurring MEETING and PHONE entries and pushes out datestamped entries.

;; schedulings-workflow.png

;; Idle States and Actions
;; Idle actions provide things for the space between. These actions are things like zeroing your inbox, reading Twitter, expanding Hacker News or Reddit, or consuming expanded articles. The idle actions list should be invisible to me when I am working, and only when I explicitely ask to be distracted should it appear.

;; States
;; IDLE Recurring Idle States
;; NEXT Idle actions waiting to be done
;; DONE Completed idle actions
;; idle-workflow.png

;; So this is interesting; they actually appear to be two seperate classes of actions, that I've bunched together for the sake of discussion. Tasks that recur in idle state, such as zeroing, will be tagged IDLE. When completed they fall back to IDLE state to be done again. Things like captured expansions come in as NEXT, so that they can be closed out as DONE once you've read them.

;; Tagging
;; A core part of my workflow is that of Tagging capture entries. It lets me easily and semantically filter the types of tasks that I have, generate well defined block agendas, and generally makes things much easier to do.

;; I have two main types of tags, I have geospatial tags and I have context tags.

;; Geospatial tags are tags that relate to a place that a task can be done. @OFFICE for example are tasks that can only be completed while physically being in the office. These differ from WORK tasks, because I can do work anywhere that I have a laptop and internet connection.

;; Context tags are the type of work that these tasks encompass; are they SHOPPING items that I need to get, are they related to my HEALTH like my Exercise habits?

(setq org-tag-alist '((:startgroup)
                      ("@STORE" . ?s)
                      ("@WORK" . ?w)
                      ("@HOME" . ?H)
                      (:endgroup)
                      ("WAITING" . ?w)
                      ("HOLD" . ?h)
                      ("PROJECT" . ?P)
                      ("WORK" . ?W)
                      ("HEALTH" . ?F)
                      ("SHOPPING" . ?S)
                      ("NOTE" . ?n)
                      ("CANCELLED" . ?c)
                      ("FLAGGED" . ??)))

;; Use expert mode to insert tags.

(setq org-fast-tag-selection-single-key 'expert)

;; Ignore hidden tags in Org Agenda tags-todo search

(setq org-agenda-tags-todo-honor-ignore-options t)

;; Capturing

;; The bulk of my days center around interupts. The old saying goes "nothing goes as planned", and this includes my daily schedule. My task tracking workflow needs to accomadate for this reality, making it easy to context switch to entirely new threads of work with a single keystroke.

;; Things I capture:

;; Emails that need to be responded to
;; Tasks and interrupts that need to be worked on
;; Web pages, documents and images to review, read or view at a later date (Idle Actions)
;; Notes from unscheduled meetings and discussions
;; We almost always refile in to ~/org/refile.org. The name of the file says it all; tasks aren't supposed to live in there, it's just a staging ground for where they will eventually live.

(if (and (fboundp 'cce-bcs-minor-mode) cce-bcs-minor-mode)
    (setq org-default-notes-file "~/org/mobile.org")
  (setq org-default-notes-file "~/org/refile.org"))

;; Bring up the Org capture dialog on C-c c

(global-set-key (kbd "C-c c") 'org-capture)

;; Capture Templates
;; Start out with an empty list.

(setq org-capture-templates '())

;; Our default Task tracking template is bound to t; this will stick the item in to refile with the NEXT state; I can change the task state if that isn't accurate, but for most things I capture that is the case.

(add-to-list 'org-capture-templates '("t" "task" entry (file org-default-notes-file)
                                      "* NEXT %?\n%U\n%a\n" :clock-in t :clock-resume t) t)

;; We also have a capture template for interrupts. They're almost always going to come in as NEXT, just like our default Tasks tracking template. These differ from Tasks in that I immediately start to work on them.

;; When I finish the task, I jump to the entry using hydra-workflow, mark it as done, and Org will clock me back in to my previous task or to the Organization task.

(add-to-list 'org-capture-templates '("i" "interupt" entry (file org-default-notes-file)
                                      "* %?\n%U\n%a\n" :clock-in t :clock-resume t :clock-keep t) t)

;; Phone call template; I still have to get the BBDB integration to work with BBDB3, but I can still easily capture these, as unlikely as unscheduled calls are for me.

(add-to-list 'org-capture-templates '("P" "Phone call" entry (file org-default-notes-file)
                                      "* PHONE Phone call with %? :PHONE:\n%U" :clock-in t :clock-resume t) t)

;; A similar template for meetings. I feel like these two templates will need to get augmented a bit, but for now they work decently enough. These are specifically for non-schedule meetings.

(add-to-list 'org-capture-templates '("m" "Meeting" entry (file org-default-notes-file)
                                      "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t) t)

;; For scheduled meetings, I should use the Scheduled template:

(add-to-list 'org-capture-templates '("s" "Scheduled Action" entry (file+datetree "~/org/diary.org")
                                      "* %?\n%U\n" :clock-in t :clock-resume t) t)
;; I have a few Idle State actions, b Bookmark, r Read later, e respond to Email. I also have a generic w for capturing things via Org-protocol that don't have a defined inbound already, but that should be avoided.

(add-to-list 'org-capture-templates '("R" "Reading Link" entry (file org-default-notes-file)
                                      "* DONE Read %c :IDLE:\n%U\n" :clock-in t :clock-resume f) t)
(add-to-list 'org-capture-templates '("r" "Read later" entry (file+headline "~/org/lists.org" "Pocket Entries")
                                      "* NEXT Read %a :IDLE:\n:PROPERTIES:\n:url: %l\n:END:\n%U\n") t)
(add-to-list 'org-capture-templates '("e" "respond" entry (file org-default-notes-file)
                                      "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t) t)
(add-to-list 'org-capture-templates '("W" "Emacs Buffer (eww or w3m)" entry (file org-default-notes-file)
                                      "* NEXT Read %a\n%U" :clock-in t :clock-resume f) t)
(add-to-list 'org-capture-templates '("w" "org-protocol" entry (file org-default-notes-file)
                                      "* NEXT Review %c\n%U\n" :immediate-finish t) t)

;; Finally we have some generic capture templates: One to create new Note entries.

(add-to-list 'org-capture-templates '("n" "note" entry (file org-default-notes-file)
                                      "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t) t)

;; The ability to easily create new Habits.

(add-to-list 'org-capture-templates '("h" "Habit" entry (file org-default-notes-file)
                                      "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n") t)

;; Refiling

;; Almost all of my refile targets point the content in to ~/org/refile.org, because it's very difficult to know if a task is related to the thing that I am working on, or if it's related to a different project, or if it's just a floating thing. I dump everything in to refile and then resort them by hand as an IDLE action.

;; Refiling is done with C-c C-w within an entry.

;; Refile targets include this file and any file contributing to the agenda - up to 9 levels deep.

(setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 9)))
We refile targets using Ido, and we want to show the full outline path in the Refile to make it as easy as possible.

(setq org-completion-use-ido nil)
(setq org-refile-use-outline-path nil)
(setq org-outline-path-complete-in-steps nil)
Allow refile to create parent tasks with confirmation

(setq org-refile-allow-creating-parent-nodes 'confirm)
Log when we refile.

(setq org-log-refile 'time)
Exclude DONE state tasks from refile targets.

(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)
Cache the refile targets, so that it works a bit quicker; It can be refreshed with C-u C-u C-u C-u C-w.

(setq org-refile-use-cache t)
Timestamps
All of my tasks should have timestamps for their creation.

(defvar bh/insert-inactive-timestamp t)

(defun bh/toggle-insert-inactive-timestamp ()
  (interactive)
  (setq bh/insert-inactive-timestamp (not bh/insert-inactive-timestamp))
  (message "Heading timestamps are %s" (if bh/insert-inactive-timestamp "ON" "OFF")))

(defun bh/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

(defun bh/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

(defun bh/insert-heading-inactive-timestamp ()
  (save-excursion
    (when bh/insert-inactive-timestamp
      (org-return)
      (org-cycle)
      (bh/insert-inactive-timestamp))))

(defvar bh/insert-inactive-timestamp t)

(defun bh/toggle-insert-inactive-timestamp ()
  (interactive)
  (setq bh/insert-inactive-timestamp (not bh/insert-inactive-timestamp))
  (message "Heading timestamps are %s" (if bh/insert-inactive-timestamp "ON" "OFF")))

(defun bh/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

(defun bh/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

(defun bh/insert-heading-inactive-timestamp ()
  (save-excursion
    (when bh/insert-inactive-timestamp
      (org-return)
      (org-cycle)
      (bh/insert-inactive-timestamp))))

(setq org-link-mailto-program '(compose-mail "%a" "%s"))

(add-hook 'org-insert-heading-hook 'bh/insert-heading-inactive-timestamp 'append)

(setq org-export-with-timestamps nil)

;; Time Tracking

;; Time Tracking is a useful habit for many reasons. It provides a wealth of data that you can use to improve your workflow and your general efficiency; it can show you where you are struggling and give you a frame of reference that no other tool can accurately do. Time Tracking can be about billing, if you're a contractor or if you're paid hourly. I am not, I'm a salary worker, but it is still, in my opinion, important to make sure that you're reaching a certain level of efficiency in your work.

;; Org mode provides time tracking as a first class citizen, you can use it to do the logging itself, as well as analyze and visualize the data.

;; Core ideas:

;; Time track everything; not for the benefit of your employer but as a way to gauge the efficiency and efficacy of your work. By quantifying these things, we provide a data source that can be later analyized to see if I am too interupted, if I am struggling on a project, and what class of tasks I most often find myself blocked on or blocked by. My environment should yell at me if I am not tracking my time when I am working on a work or personal project.
;; Time tracking should be painless, and integrated in to my workflow; clocking in and out at the end of the day should be an easy act, a single keystroke that I can hit when I open up my laptop at the office and again at the end of the day. Jumping from task to task should be similarly painless, a single keystroke will allow me to change context to a new or existing task.
;; My workflow is based on Bernt's workflow; I have a default task that I clock in to when I'm doing anything productive, that is my "Organization" task. That is a global variable that any of my helper functions can grab and do things with.

(defvar organization-task-id nil)

(cce/with-any-domain '("kusanagi" "main" "pocket" "penguin" "tres-ebow" "solitary-living")
  (setq organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9"))
(cce/with-any-domain '("work" "beebs")
  (setq organization-task-id "324d80c8-c305-4930-b613-853978b8c54b"))

;; When trying to clock in to a different task using hydra-workflow we want to make sure that there are a lot of choices.

(setq org-clock-history-length 23)

;; Always be clocking. If I leave a clock open, to deal with a capture or such, we should keep that clock open and resume it the next time we get back to it.

(setq org-clock-in-resume t)

;; Resolve clocks that are left open for longer than an hour, which leaves me time for lunch, but encourages me to do more granular task clocking for.

(setq org-clock-idle-time 60)

;; Clocker mode helps ensure that I'm always in a clocking state. It basically nags the fuck out of you. :)

(install-pkgs '(clocker))
(require 'clocker)
(diminish 'clocker-mode "[C]")
;(clocker-mode 1)

;; Helper functions for clocking system. When you finish a task and clock out of it, bh/clock-out-maybe will clock in the parent Project task which is nice. If the parent task is closed, it clocks the default Organization task.

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
             (not org-clock-clocking-in)
             (marker-buffer org-clock-default-task)
             (not org-clock-resolving-clocks-due-to-idleness))
    (rrix/clock-in-sibling-or-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

(defun rrix/clock-in-sibling-or-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task)
        (parent-task-is-flow)
        (sibling-task)
        (curpoint (point)))
    (save-excursion
      (save-restriction
        (widen)
        (outline-back-to-heading)
        (org-cycle)
        (while (and (not parent-task) (org-up-heading-safe))
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (goto-char curpoint)
        (while (and (not sibling-task) (org-get-next-sibling))
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq sibling-task (point))))
        (setq parent-task-is-flow (cdr (assoc "FLOW"
                                              (org-entry-properties parent-task))))
        (cond ((and sibling-task
                    parent-task-is-flow)
               (org-with-point-at sibling-task
                 (org-clock-in))
               (org-clock-goto))
              (parent-task
               (org-with-point-at parent-task
                 (org-clock-in))
               (org-clock-goto))
              (t (when bh/keep-clock-running
                   (bh/clock-in-default-task))))))))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in)
      (org-clock-goto))))

;; We want to clock in to its own drawer, in this case LOGBOOK.

(setq org-clock-into-drawer t)
(setq org-drawers '("PROPERTIES" "LOGBOOK"))

;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration

(setq org-clock-out-remove-zero-time-clocks t)

;; This function is bound in to hydra-workflow and clocks you in to the last task you were clocked in to; this is useful when jumping around on interrupts and stuff.

(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4) org-clock-default-task)
          ((and (org-clock-is-active)
                (equal org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active) (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
          (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

;; Clock out when moving task to a done state. This is how my workflow progresses; I have a workflow set up such that when a task is done, I clock out of it, then go and clock in to the next most recent task, all the way down the chain to Organization. bh/clock-out-maybe does that clock walking for us, and bh/keep-clock-running is a state variable for that function.

(setq org-clock-out-when-done t)

(setq bh/keep-clock-running nil)
(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

;; We want to try to clock back in to the previous task if we have to restart Emacs.

(org-clock-persistence-insinuate)
(setq org-clock-persist t)
(setq org-clock-persist-query-resume nil)
(setq org-clock-auto-clock-resolution 'when-no-clock-is-running)

;; Include current clocking task in clock reports.

(setq org-clock-report-include-clocking-task t)

;; Don't ever round our timestamps.

(setq org-time-stamp-rounding-minutes '(1 1))

;; Make sure that you don't clock for too long. There's no reason to clock for four straight hours, and if I do that, I'm probably lying.

(setq org-agenda-clock-consistency-checks
      '(:max-duration "4:00"
        :min-duration 0
        :max-gap 0
        :gap-ok-around ("4:00")))

;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration

(setq org-clock-out-remove-zero-time-clocks t)

;; This block configures the Agenda clock report10. See its infodoc for more information.

(setq org-agenda-clockreport-parameter-plist
      '(:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80))

;; When columnizing org tasks, we can format how they look like this.

(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

;; Set global properties that apply to all org entries' autocompletes

(setq org-global-properties '(quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                     ("STYLE_ALL" . "habit"))))
;; In Org Agenda Log Mode, show all the information about them that we can.

(setq org-agenda-log-mode-items '(closed state clock))

;; When we clock in to a task, we should change the state of its parent projects to INPROGRESS

(defun bh/mark-next-parent-tasks-todo ()
  "Visit each parent task and change NEXT states to TODO"
  (let ((mystate (or (and (fboundp 'org-state)
                          state)
                     (nth 2 (org-heading-components)))))
    (when mystate
      (save-excursion
        (while (org-up-heading-safe)
          (when (member (nth 2 (org-heading-components)) (list "NEXT"))
            (org-todo "INPROGRESS")))))))
(add-hook 'org-after-todo-state-change-hook 'bh/mark-next-parent-tasks-todo 'append)
(add-hook 'org-clock-in-hook 'bh/mark-next-parent-tasks-todo 'append)

;; PLANNING Work on the Emacs workflow system
;; Simple workflow system to keep you on task for recurring tasks. Getting ready in the morning, starting off the day at the office, weekend chores

;; Define a list of functions that you walk through:

(defworkflow work-start
 (("Start Clocking Day" (progn
                         (bh/clock-in-organization-task-as-default)
                         (wf/clock-in "4b20bfb5-0da4-4dbe-ad90-f3f5757aa5c5")))
  ("Sync Calendar" (org-caldav-sync))
  ("Check email" (progn
                  (wf/clock-in "0a3beb6e-d20c-47c9-bff4-615c1f59ef88")
                  (gnus)))
  ("Today's Agenda" (org-agenda "" "w"))
  ("Get to work" (wf/work-start-reset))))
;; This will generate a wf/work-start-state variable which will cache the list of tasks still needed to be run, as well as a few functions:

;; wf/work-start, which will execute the car from wf/work-start-state, and store the cdr back in to wf/work-start-state
;; wf/work-start-reset, which will reset wf/work-start-state to its initial value
;; Possible uses:

;; Git workflows
;; Meeting workflows
;; Outage communication workflows (RJR: This will need some sort of timer system "contact outages@ every 30 minutes")
;; Weekly review blogging workflow
;; Daily startup workflow
;; NEXT Automatically clock in to :flow: t children using org-goto-first-child
;; Footnotes:
;; 1
;; http://orgmode.org/

;; 2
;; http://orgmode.org/w/?p=org-mode.git;a=blob_plain;f=lisp/org-gnus.el;hb=HEAD

;; 3
;; http://orgmode.org/w/?p=org-mode.git;a=blob_plain;f=lisp/org-id.el;hb=HEAD

;; 4
;; https://www.gnu.org/software/emacs/manual/html_node/org/Tracking-your-habits.html

;; 5
;; http://orgmode.org/cgit.cgi/org-mode.git/plain/lisp/org-irc.el

;; 6
;; http://orgmode.org/worg/org-contrib/org-protocol.html

;; 7
;; http://orgmode.org/w/?p=org-mode.git;a=blob_plain;f=lisp/org-w3m.el;hb=HEAD

;; 8
;; http://orgmode.org/w/?p=org-mode.git;a=blob_plain;f=lisp/org-bbdb.el;hb=HEAD

;; 9
;; http://orgmode.org/manual/Capture-templates.html

;; 10
;; See clock report mode in http://orgmode.org/manual/Agenda-commands.html
