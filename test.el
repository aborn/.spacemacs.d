(defun test-butle (arg)
  "only used for ws-butler-global-mode test"
  (interactive "p")
  (message "turn off ws-butler-global-mode")
  (ws-butler-global-mode -1))


(zzz-to-char .
             [(20160122 440)
              ((emacs (24 4)) (cl-lib (0 5)) (avy (0 3 0)))
              "Fancy version of `zap-to-char' command"
              single
              ((:url . "https://github.com/mrkkrp/zzz-to-char") (:keywords "convenience"))
              ])


(defun ab/copy-to-clipboard (arg)
  "copy string content to clipboard"
  (interactive "P")
  (let* ((pkg-string-content (format-time-string "%Y-%m-%d.%H.%M" (current-time))))
    (kill-new pkg-string-content)))


(fset 'return-a-marked-pos
      (lambda (&optional arg)
        "Keyboard macro."
        (interactive "p")
        (kmacro-exec-ring-item
         (quote ([21 134217848 115 101 116 45 109 97 114 107 45 99 111 109 109 97 110 100 return] 0 "%d")) arg)))

(require 'widget-demo)
(require 'cip-mode)
