(provide 'emacs-nifty-tricks)

(defun aborn/insert-date (prefix)
  "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%Y-%m-%d")
                 ((equal prefix '(4)) "%Y-%m-%d")
                 ((equal prefix '(16)) "%A, %d. %B %Y")))
        (system-time-locale "zh_CN"))
    (insert (format-time-string format))))

(defun insert-date-format (format)
  "Wrapper around format-time-string." 
  (interactive "MFormat: ")
  (insert (format-time-string format)))


(defun insert-standard-date ()
  "Inserts standard date time string." 
  (interactive)
  (insert (format-time-string "%c")))

