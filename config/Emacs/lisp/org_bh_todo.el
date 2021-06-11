;; * Tasks and States
;; :PROPERTIES:
;; :CUSTOM_ID: TasksAndStates
;; :END:

;; I use one set of TODO keywords for all of my org files.  Org-mode lets
;; you define TODO keywords per file but I find it's easier to have a
;; standard set of TODO keywords globally so I can use the same setup in
;; any org file I'm working with.

;; The only exception to this is this document :) since I don't want
;; =org-mode= hiding the =TODO= keyword when it appears in headlines.
;; I've set up a dummy =#+SEQ_TODO: FIXME FIXED= entry at the top of this
;; file just to leave my =TODO= keyword untouched in this document.
;; ** TODO keywords
;; :PROPERTIES:
;; :CUSTOM_ID: TodoKeywords
;; :END:

;; I use a light colour theme in emacs.  I find this easier to read on bright sunny days.

;; Here are my =TODO= state keywords and colour settings:

;; #+header: :tangle yes
;; #+begin_src emacs-lisp
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "INPROGRESS(i)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("INPROGRESS" :foreground "burlywood" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))
;; #+end_src
;; *** Task States
;; :PROPERTIES:
;; :CUSTOM_ID: TodoKeywordTaskStates
;; :END:

;; Tasks go through the sequence =TODO= -> =DONE=.

;; The following diagram shows the possible state transitions for a task.

;; #+begin_src plantuml :file normal_task_states.png :cache yes
;; title Task States
;; [*] -> TODO
;; TODO -> NEXT
;; TODO -> DONE
;; NEXT -> DONE
;; DONE -> [*]
;; TODO --> WAITING
;; WAITING --> TODO
;; NEXT --> WAITING
;; WAITING --> NEXT
;; HOLD --> CANCELLED
;; WAITING --> CANCELLED
;; CANCELLED --> [*]
;; TODO --> HOLD
;; HOLD --> TODO
;; TODO --> CANCELLED
;; TODO: t
;; NEXT: n
;; DONE: d
;; WAITING:w
;; note right of WAITING: Note records\nwhat it is waiting for
;; HOLD:h
;; note right of CANCELLED: Note records\nwhy it was cancelled
;; CANCELLED:c
;; WAITING --> DONE
;; #+end_src

;; #+results[61c867b8eb4f49bc47e44ec2b534ac3219d82594]:
;; [[file:normal_task_states.png]]

;; *** Project Task States
;; :PROPERTIES:
;; :CUSTOM_ID: TodoKeywordProjectTaskStates
;; :END:

;; I use a lazy project definition.  I don't like to bother with manually
;; stating 'this is a project' and 'that is not a project'.  For me a project
;; definition is really simple.  If a task has subtasks with a todo keyword
;; then it's a project.  That's it.

;; Projects can be defined at any level - just create a task with a todo
;; state keyword that has at least one subtask also with a todo state
;; keyword and you have a project.  Projects use the same todo keywords
;; as regular tasks.  One subtask of a project needs to be marked =NEXT=
;; so the project is not on the stuck projects list.
;; *** Phone Calls
;; :PROPERTIES:
;; :CUSTOM_ID: TodoKeywordPhoneCalls
;; :END:

;; Telephone calls are special.  They are created in a done state by a capture task.
;; The time of the call is recorded for as long as the capture task is active.  If I need 
;; to look up other details and want to close the capture task early I can just 
;; =C-c C-c= to close the capture task (stopping the clock) and then =f9 SPC= to resume
;; the clock in the phone call while I do other things.
;; #+begin_src plantuml :file phone_states.png :cache yes
;; title Phone Call Task State
;; [*] -> PHONE
;; PHONE -> [*]
;; #+end_src

;; #+results[9e27f3a56c4fca8f05455e6dfa1282030ae52830]:
;; [[file:phone_states.png]]

;; *** Meetings
;; :PROPERTIES:
;; :CUSTOM_ID: TodoKeywordMeetings
;; :END:

;; Meetings are special.  They are created in a done state by a capture
;; task.  I use the MEETING capture template when someone interrupts what
;; I'm doing with a question or discussion.  This is handled similarly to
;; phone calls where I clock the amount of time spent with whomever it is
;; and record some notes of what was discussed (either during or after
;; the meeting) depending on content, length, and complexity of the
;; discussion.

;; The time of the meeting is recorded for as long as the capture task is
;; active.  If I need to look up other details and want to close the
;; capture task early I can just =C-c C-c= to close the capture task
;; (stopping the clock) and then =f9 SPC= to resume the clock in the
;; meeting task while I do other things.
;; #+begin_src plantuml :file meeting_states.png :cache yes
;; title Meeting Task State
;; [*] -> MEETING
;; MEETING -> [*]
;; #+end_src

;; #+results[942fb408787905ffcdde421ee02edabdbb921b06]:
;; [[file:meeting_states.png]]

;; ** Fast Todo Selection
;; :PROPERTIES:
;; :CUSTOM_ID: FastTodoSelection
;; :END:

;; Fast todo selection allows changing from any task todo state to any
;; other state directly by selecting the appropriate key from the fast
;; todo selection key menu.  This is a great feature!

;; #+header: :tangle yes
;; #+begin_src emacs-lisp 
(setq org-use-fast-todo-selection t)
;; #+end_src

;; Changing a task state is done with =C-c C-t KEY=

;; where =KEY= is the appropriate fast todo state selection key as defined in =org-todo-keywords=.

;; The setting
;; #+header: :tangle yes
;; #+begin_src emacs-lisp
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
;; #+end_src
;; allows changing todo states with S-left and S-right skipping all of
;; the normal processing when entering or leaving a todo state.  This
;; cycles through the todo states but skips setting timestamps and
;; entering notes which is very convenient when all you want to do is fix
;; up the status of an entry.
;; ** TODO state triggers
;; :PROPERTIES:
;; :CUSTOM_ID: ToDoStateTriggers
;; :END:

;; I have a few triggers that automatically assign tags to tasks based on
;; state changes.  If a task moves to =CANCELLED= state then it gets a
;; =CANCELLED= tag.  Moving a =CANCELLED= task back to =TODO= removes the
;; =CANCELLED= tag.  These are used for filtering tasks in agenda views
;; which I'll talk about later.

;; The triggers break down to the following rules:

;; - Moving a task to =CANCELLED= adds a =CANCELLED= tag
;; - Moving a task to =WAITING= adds a =WAITING= tag
;; - Moving a task to =HOLD= adds =WAITING= and =HOLD= tags
;; - Moving a task to a done state removes =WAITING= and =HOLD= tags
;; - Moving a task to =TODO= removes =WAITING=, =CANCELLED=, and =HOLD= tags
;; - Moving a task to =NEXT= removes =WAITING=, =CANCELLED=, and =HOLD= tags
;; - Moving a task to =DONE= removes =WAITING=, =CANCELLED=, and =HOLD= tags

;; The tags are used to filter tasks in the agenda views conveniently.

;; #+header: :tangle yes
;; #+begin_src emacs-lisp 
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
;; #+end_src
;; * Adding New Tasks Quickly with Org Capture
;; :PROPERTIES:
;; :CUSTOM_ID: Capture
;; :END:
