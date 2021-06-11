(defun directory-dirs (dir)
  "Find all directories in DIR."
  (unless (file-directory-p dir)
    (error "Not a directory `%s'" dir))
  (let ((dir (directory-file-name dir))
        (dirs '())
        (files (directory-files dir nil nil t)))
    (dolist (file files)
      (unless (member file '("." ".."))
        (let ((file (concat dir "/" file)))
          (when (file-directory-p file)
            (setq dirs (append (cons file
                                     (directory-dirs file))
                               dirs))))))
    dirs))


(setq my-org-agenda-root "/c/Users/sfuller/Dev")
(setq my-org-agenda-files-list "~/.emacs.d/org-agenda-list.el")

(defun my-update-org-agenda-files ()
  "Create or update the `my-org-agenda-files-list' file.

This file contains elisp code to set `org-agenda-files' to a
recursive list of all children under `my-org-agenda-root'. "
  (interactive)
  (with-temp-buffer
    (insert
     ";; Warning: this file has been automatically generated\n"
     ";; by `my-update-org-agenda-files'\n")
    (let ((dir-list (directory-dirs my-org-agenda-root))
          (print-level nil)
          (print-length nil))
      (cl-prettyprint `(setq org-agenda-files (quote ,dir-list))))
    (write-file my-org-agenda-files-list)))

(load my-org-agenda-files-list)
