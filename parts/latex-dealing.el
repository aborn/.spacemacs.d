(provide 'latex-dealing)

(defun ab/latex-add-ref (arg)
  "Add a reference at current point
   Binding to C-x j in BibTex mode"
  (interactive "P")
  (insert-string "@Inproceedings{,\n")
  (insert-string "  author = {},\n")
  (insert-string "  title = \"\",\n")
  (insert-string "  booktitle = \"\",\n")
  (insert-string "  pages = {-},\n")
  (insert-string "  year = \"\",\n")
  (insert-string "}")
  )

(defun ab/latex-compile-current-file (arg)
  "Compile current latex file
   Binding to C-x j in latex-mode"
  (interactive "P")
  (setq cw (selected-window))
  (setq cfname (buffer-file-name (current-buffer)))
  (setq cmdStr (concat "pdflatex " cfname))
  (message "Running...")
  (shell-command cmdStr "*latex-compile-output*" )
  (select-window (get-buffer-window "*latex-compile-output*"))
  (end-of-buffer)
  (insert "---------------------------\n")
  (insert (concat "Compile finish time:" 
                  (current-time-string) "\n" user-full-name "\n"))
  (insert "---------------------------")
  (when (window-valid-p cw)
    (select-window cw)))

(defun ab/latex-insert-marker (arg)
  "Insert a marker in current point in latex file (.tex)"
  (interactive "P")
  (insert "[\\textcolor[rgb]{1.0, 0.0, 0.0}{MarkerHere}]"))

