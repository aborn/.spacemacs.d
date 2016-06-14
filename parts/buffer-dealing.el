(provide 'buffer-dealing)

(defun buffer-mode (buffer-or-string)
  "Returns the major mode associated with a buffer."
  (with-current-buffer buffer-or-string
    major-mode))

(defun get-buffer-mode-name (buffer-or-string)
  "Get the buffer major mode name."
  (interactive "bBuffer Name:")
  (message (with-current-buffer buffer-or-string
             major-mode)))

(defun get-current-file-name (arg)
  "Get the current buffer's file name"
  (interactive "P")
  (message (buffer-file-name (current-buffer)))) 

(defun ab/switch-buffer-each-other (arg)
  "switch current buffer with other window buffer 
   right-2-left and up-2-down"
  (interactive "p")
  (cond
   ((windmove-find-other-window 'right) (buf-move-right))
   ((windmove-find-other-window 'left) (buf-move-left))
   ((windmove-find-other-window 'up) (buf-move-up))
   ((windmove-find-other-window 'down) (buf-move-down)))
  (message "switch buffer done"))

(defun ab-kill-buff (arg)
  "my defined kill-buff related with ecb"
  (interactive "P")
  (ab/ecb-deactivate)
  (kill-buffer)
  (ab/ecb-activate))

(defun buffer-exists (bufname)   
  (not (eq nil (get-buffer bufname))))

(defvar ab/compile-log-buffer-name "*Compile-Log*")
(defun ab/save-compile-log-by-date (arg)
  "save each package install *Compile-Log* buffer content"
  (interactive "P")
  (if (not (buffer-exists ab/compile-log-buffer-name))
      (message "not buffer name *Compile-Log* exists!")
    (progn
      (let* ((current-buffer-save (current-buffer))
             (current-time-stamp-local
              (format-time-string "%Y-%m-%d-%H" (current-time)))
             (compile-log-file-name
              (format "~/.spacemacs.d/local/compile-log-%s.txt" current-time-stamp-local)))
        (save-current-buffer
          (message "*Compile-Log* save to '%s'" compile-log-file-name)
          (set-buffer ab/compile-log-buffer-name)
          (write-file compile-log-file-name)
          (save-buffer))))))

;; -----------------------------------------------------------------
;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
;; -----------------------------------------------------------------
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (progn
            (message "A buffer named '%s' already exists! Use another name!" new-name)
            (rename-file name new-name 1)
            (rename-buffer (concat new-name "#" name))
            (set-visited-file-name new-name)
            (set-buffer-modified-p nil))
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))


(defalias 'ab/buffer-exists 'buffer-exists)
(defalias 'ab/shell 'make-shell)
(defalias 'ab/rename 'rename-file-and-buffer)
(defalias 'ab/kill-buff 'ab-kill-buff)
(defalias 'ab/delete-file 'delete-file-and-buffer)
(defalias 'swap-buffer 'switch-buffer-each-other)
