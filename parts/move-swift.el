(provide 'move-swift)
(defun move-middle-of-line (arg)
  "Move point to the middle of line current displayed" 
  (interactive "p")
  (message "move to middle of line, cur=%d." (current-column))
  (end-of-line)
  (backward-char (/ (current-column) 2)))

(defun move-forward-by-five (arg)
  "Move point forward by five lines"
  (interactive "p")
  (forward-line 5))

(defun move-backward-by-five (arg)
"Move point backward by five lines"
  (interactive "p")
  (forward-line -5))

;; http://pages.sachachua.com/.emacs.d/Sacha.html#orgheadline33
(defun my/smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'my/smarter-move-beginning-of-line)

