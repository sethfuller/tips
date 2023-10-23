
(defun bg-color (color-abbrev)
  "Set background color"
  (interactive "sEnter color ")
  (setq color nil)
  ;; (cond (((or (eq color-abbrev 'az1) (eq color-abbrev 'az)) (set-background-color "azure1"))
  ;;        ((eq color-abbrev 'gr) (setq color "gray99"))
  ;;        ))
  (message "Color Abbrev. %s" color-abbrev)
  (type-of 'color-abbrev)
  (cond ((eq color-abbrev 'az1) (setq color "azure1"))
        ((eq color-abbrev 'gr) (setq color "gray99"))
        )
  ;; (ecase color-abbrev
  ;;   (("az1") (setq color "azure1"))
  ;;   (("gr") (setq color "gray99"))
  ;;   )
  (if (eq color nil)
      (message "Invalid Color Abbrev. %s %s" color-abbrev color)
    (set-background-color color)
    )
  )


(defun bg-az (ca)
  (interactive "sCA ")
  (set-background-color "azure1")
  )
