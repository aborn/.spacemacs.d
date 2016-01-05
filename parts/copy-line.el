;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; custom.el this file for aborn
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'copy-line)
(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (push-mark)
  (kill-ring-save (line-beginning-position)
				  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(defun copy-one-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (push-mark)
  (kill-ring-save (line-beginning-position)
				  (line-end-position))
  (message "current line copied"))
