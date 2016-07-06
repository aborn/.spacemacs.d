;; 用于打Log

(defvar ab--log-file-name "~/.spacemacs.d/local/log.txt")
(defun ab/log (log)
  (let* ((local-current-time (format-time-string "[%Y-%m-%d %H:%M:%S] " (current-time))))
    (with-temp-buffer
      (insert (concat local-current-time log))
      (insert "\n")
      (append-to-file (point-min) (point-max) ab--log-file-name))))

(provide 'aborn-log)
