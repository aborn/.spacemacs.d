;;; aborn-log.el --- 用于打Log.

;; Copyright (C) 2016 Aborn Jiang

;;; Code:

(require 'subr-x)
(defvar ab--log-file-name "~/.spacemacs.d/local/log.txt")

(defun aborn/log-format (origin)
  "Format `ORIGIN' log with timestamp."
  (concat (format-time-string "[%Y-%m-%d %H:%M:%S] " (current-time))
          origin))

(defun aborn/log (&rest args)
  "record &rest args as log into file `ab--log-file-name' and
   each line with timestamp as prefix."
  (with-temp-buffer
    (goto-char (point-max))
    (insert (aborn/log-format (string-join args " ")))
    (insert "\n")
    (append-to-file (point-min) (point-max) ab--log-file-name)))

(provide 'aborn-log)
;;; aborn-log.el ends here
