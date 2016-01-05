(provide 'shell-dealing)

(defun ab/get-default-shell-buffer-name ()
  "get default shell buffer name"
  (interactive)
  (unless (boundp 'shell-name)
    (setq shell-name "shell"))
  (cond ((string= shell-name "shell") 
         (message "*shell*"))
        ((string= shell-name "eshell")
         (message "*eshell*")))
  )

(defun make-eshell (name)
  "Create a new eshell buffer named NAME."
  (interactive "sName: ")
  (if (buffer-exists "*eshell*")
      (setq eshell-buffer-name name)
    (message "eshell doesnot exists, use the default name: *eshell*"))
  (eshell))

(defun make-bshell (name)
  "Create a default shell buffer named NAME"
  (interactive "sName: ")
  (unless (buffer-exists "*shell*")
    (message "eshell doesnot exists, use the default name: *eshell*")
    (setq name "*shell*"))
  (shell name))

(defun make-shell (name)
  "Create a shell(or eshell) buffer named NAME"
  (interactive "sName: ")
  (cond ((string= shell-name "eshell")
        (make-eshell name)
        (message "make eshell."))
       ((string= shell-name "shell")
        (make-bshell name)
        (message "make default shell."))
       ))

(defun ab/shell-buffer? ()
  "return t if the current buffer is shell buffer"
  (setq bfname (ab/get-current-window-buffer-name))
  (if (string-match "shell" bfname)
      (message bfname)      ;; show shell name if it is a shell
    nil                     ;; or return nil
    ))

(defun ab/switch-to-shell-buffer (arg)
  "Swith to *shell* buff"
  (interactive "p")
  (select-window (ab/get-window-at-right-botton))
  (unless (ab/shell-buffer?)
    (unless (get-buffer (ab/get-default-shell-buffer-name))
      (make-shell (ab/get-default-shell-buffer-name)))
    (switch-to-buffer (ab/get-default-shell-buffer-name)))
  (end-of-buffer))  ;; point to end of the buffer

