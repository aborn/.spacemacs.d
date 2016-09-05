(defun aborn/create-scratch-buffer nil
  "create a scratch buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun aborn/just-one-space-debug ()
  "Only for debug"
  (interactive)
  (message "count %d" (aborn/cal-space-count)))

(defun aborn/cal-space-count ()
  "Count how many space char."
  (let ((char-list (list (char-after)
                         (char-before))))
    (when (aborn/is-space (char-after))
      (push (char-after (+ 1 (point))) char-list))
    (when (aborn/is-space (char-before))
      (push (char-before (- (point) 1)) char-list))
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
  "Intelligent version of just-one-space."
  (interactive "*p")
  (if (or (> (aborn/cal-space-count) 1)
          (= (aborn/cal-space-count) 0))
      (just-one-space)
    (just-one-space 0)))

(defun aborn/get-ip (arg)
  "Get current machine local ip adress."
  (interactive "P")
  (insert (shell-command-to-string "ifconfig |egrep \"10\\.|172\\.|192\\.\" |awk '{print $2}'")))

(defun aborn/copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (or
                       (eq major-mode 'dired-mode)
                       (eq major-mode 'inferior-emacs-lisp-mode)
                       (eq major-mode 'term-mode))
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "File name was copied '%s' to the clipboard." filename))))

(defun aborn/backward-kill-word ()
  "Customize backward-kill-word for RET."
  (interactive)
  (let* ((pos (search-backward "\n")))
    (message "%s %s" (point) pos)))

(provide 'aborn-utils)
