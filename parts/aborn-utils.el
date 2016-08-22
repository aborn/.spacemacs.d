(defun aborn/create-scratch-buffer nil
  "create a scratch buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun aborn/debug ()
  "interactive"
  (interactive)
  (message "is-space:%s number:%d"
           (aborn/is-space (char-after))
           (aborn/cal-space-count)))

(defun aborn/cal-space-count ()
  "Count how many space."
  (let ((char-list (list (char-after)
                         (char-before))))
    (when (aborn/is-space (char-after))
      (add-to-list 'char-list (char-after (+ 1 (point)))))
    (when (aborn/is-space (char-before))
      (add-to-list 'char-list (char-before (- (point) 1))))
    (reduce '+
            (mapcar
             #'(lambda (x)
                 (if (aborn/is-space x)
                     1
                   0))
             char-list))
    ))

(defun aborn/is-space (char)
  (or (eq ?\b char)   ;; 8 backspace, BS, C-h
      (eq ?\t char)   ;; 9 tab, TAB, C-i
      (eq ?\n char)   ;; 10 newline, C-j
      (eq ?\v char)   ;; 11 vertical tab, C-k
      (eq ?\s char)   ;; 32 space character, SPC
      ))

(defun aborn/just-one-space (&optional n)
  "Smart version of just-one-space"
  (interactive "*p")
  (if (or (> (aborn/cal-space-count) 1)
          (= (aborn/cal-space-count) 0))
      (just-one-space)
    (just-one-space 0)))

(provide 'aborn-utils)
