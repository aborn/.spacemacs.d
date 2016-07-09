;; 用于打Log
(require 'subr-x)
(defvar ab--log-file-name "~/.spacemacs.d/local/log.txt")

(defun ab/log (&rest args)
  "record &rest args as log into file `ab--log-file-name' and
   each line with timestamp as prefix."
  (let* ((local-current-time (format-time-string "[%Y-%m-%d %H:%M:%S] " (current-time))))
    (with-temp-buffer
      (insert (concat local-current-time (string-join args " ")))
      (insert "\n")
      (append-to-file (point-min) (point-max) ab--log-file-name))))

(provide 'aborn-log)
