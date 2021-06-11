;; Collect all .org from my Org directory and subdirs
(setq org-agenda-file-regexp "\\`[^.].*\\.org\\'") ; default value
(defun load-org-agenda-files-recursively (dir) "Find all directories in DIR."
    (unless (file-directory-p dir) (error "Not a directory `%s'" dir))
    (unless (equal (directory-files dir nil org-agenda-file-regexp t) nil)
;;      (print "dir: " . dir)
      (add-to-list 'org-agenda-files dir)
    )
    (dolist (file (directory-files dir nil nil t))
        (unless (member file '("." ".."))
            (let ((file (concat dir file "/")))
                (when (file-directory-p file)
                    (load-org-agenda-files-recursively file)
                )
            )
        )
    )
)
;; (load-org-agenda-files-recursively "/c/Users/sfuller/Dev/SPARK/tasks/" ) ; trailing slash required
;; (load-org-agenda-files-recursively "/c/Users/sfuller/Dev/SPARK/work/" ) ; trailing slash required
