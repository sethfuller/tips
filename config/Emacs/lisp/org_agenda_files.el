(defun org-get-agenda-files-recursively (dir)
  "Get org agenda files from root DIR."
  (directory-files-recursively dir "\.org$"))

(defun org-set-agenda-files-recursively (dir)
  "Set org-agenda files from root DIR."
  (setq org-agenda-files 
    (org-get-agenda-files-recursively dir)))

(defun org-add-agenda-files-recursively (dir)
  "Add org-agenda files from root DIR."
  (nconc org-agenda-files 
    (org-get-agenda-files-recursively dir)))

(setq org-agenda-files nil) ; zero out for testing

(org-set-agenda-files-recursively "/c/Users/sfuller/Dev/SPARK") ; test set
(org-set-agenda-files-recursively "/c/Users/sfuller/Dev/FOCUS") ; test set

;; (org-add-agenda-files-recursively "~/Dropbox") ; test add
