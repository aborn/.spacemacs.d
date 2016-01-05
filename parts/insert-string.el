(provide 'insert-string)

(defun ab/insert-email-address (arg)
  "Insert email address at the current ponit"
  (interactive "p")
  (unless (boundp 'user-mail-address)   ;; check variable defined.
    (setq user-mail-address "aborn.jiang@foxmail.com"))
  (insert-string user-mail-address))
;;  (insert-string email-address))

(defun ab/insert-name-english (arg)
  "Insert english name at the current ponit"
  (interactive "p")
  (unless (boundp 'user-full-name)
    (setq user-full-name  "Aborn Jiang"))
  (insert-string user-full-name))

(defun ab/insert-name-chinese (arg)
  "Insert english name at the current ponit"
  (interactive "p")
  (unless (boundp 'chinese-name)
    (setq chinese-name  "蒋国宝"))
  (insert-string chinese-name))

(defun ab/insert-buffer-name (arg)
  "Insert buffer name at the current point"
  (interactive "p")
  (insert-string (buffer-name)))

(defun insert-current-time (arg)
  "Insert time to current point"
  (interactive "P")
  (insert-string (current-time-string)))

(defun insert-current-buffer-file-name (arg)
  "Insert current buffer file name (full path)"
  (interactive "P")
  (insert-string (buffer-file-name (current-buffer))))

(defun ab/insert-tab-space (arg)
  "Insert 4 white space at current point"
  (interactive "P")
  (insert-string "    "))
;; insert date and time
(defvar current-date-time-format "%Y-%m-%d.%H.%M.%S"
  "Format of date to insert with `insert-current-date-time' func
See help of `format-time-string' for possible replacements")

(defvar current-time-format "%a %H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun insert-current-date-time ()
  "insert the current date and time into current buffer.
Uses `current-date-time-format' for the formatting the date/time."
  (interactive)
  (insert (format-time-string current-date-time-format (current-time)))
  (insert "guobao\n")
  )

(defun insert-current-time ()
  "insert the current time (1-week scope) into the current buffer."
  (interactive)
  (insert (format-time-string current-time-format (current-time)))
  (insert "\n")
  )

;; ref : http://www.gnu.org/software/emacs/manual/html_node/elisp/Time-Parsing.html#Time-Parsing
