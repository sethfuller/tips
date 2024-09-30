 <!-- language: lang-lisp -->
;; https://stackoverflow.com/questions/36183071/how-can-i-preview-markdown-in-emacs-in-real-time
;;
;; Start web server
;; M-x httpd-start
;;
;; M-x impatient-mode
;;
;; Open your browser to localhost:8080/imp
;;
;; M-x imp-set-user-filter RET markdown-html RET

(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

;; Use only markdown-mode
;; https://jblevins.org/projects/markdown-mode/
;; Configure markdown-command to markdown converter on system, e.g. pandoc
;;
;; C-c C-l (markdown-insert-link) is a general command for inserting new link markup or editing existing link markup. This is especially useful when markup or URL hiding is enabled, so that URLs can’t easily be edited directly. This command can be used to insert links of any form: either inline links, reference links, or plain URLs in angle brackets. The URL or [reference] label, link text, and optional title are entered through a series of interactive prompts. The type of link is determined by which values are provided:

;; If both a URL and link text are given, insert an inline link: [text](url).
;; If both a [reference] label and link text are given, insert a reference link: [text][reference].
;; If only link text is given, insert an implicit reference link: [text][].
;; If only a URL is given, insert a plain URL link: <url>.

;; Markdown and Maintenance Commands: C-c C-c

;; Compile: C-c C-c m will run Markdown on the current buffer and show the output in another buffer. Preview: C-c C-c p runs Markdown on the current buffer and previews, stores the output in a temporary file, and displays the file in a browser. Export: C-c C-c e will run Markdown on the current buffer and save the result in the file basename.html, where basename is the name of the Markdown file with the extension removed. Export and View: press C-c C-c v to export the file and view it in a browser. Open: C-c C-c o will open the Markdown source file directly using markdown-open-command. Live Export: Press C-c C-c l to turn on markdown-live-preview-mode to view the exported output side-by-side with the source Markdown. For all export commands, the output file will be overwritten without notice. markdown-live-preview-window-function can be customized to open in a browser other than eww. If you want to force the preview window to appear at the bottom or right, you can customize markdown-split-window-direction.

;; To summarize:

;; C-c C-c m: markdown-command > *markdown-output* buffer.
;; C-c C-c p: markdown-command > temporary file > browser.
;; C-c C-c e: markdown-command > basename.html.
;; C-c C-c v: markdown-command > basename.html > browser.
;; C-c C-c w: markdown-command > kill ring.
;; C-c C-c o: markdown-open-command.
;; C-c C-c l: markdown-live-preview-mode > *eww* buffer.
;;
;; C-c C-c c will check for undefined references. If there are any, a small buffer will open with a list of undefined references and the line numbers on which they appear. In Emacs 22 and greater, selecting a reference from this list and pressing RET will insert an empty reference definition at the end of the buffer. Similarly, selecting the line number will jump to the corresponding line.

;; C-c C-c u will check for unused references. This will also open a small buffer if any are found, similar to undefined reference checking. The buffer for unused references will contain X buttons that remove unused references when selected.

;; C-c C-c n renumbers any ordered lists in the buffer that are out of sequence.

;; C-c C-c ] completes all headings and normalizes all horizontal rules in the buffer.
