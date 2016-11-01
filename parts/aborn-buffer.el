;;; aborn-buffer.el --- buffer utils function.  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Aborn Jiang

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; Buffer utils function.
;;

;;; Code:

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

(defun aborn/switch-buffer-each-other (arg)
  "switch current buffer with other window buffer 
   right-2-left and up-2-down"
  (interactive "p")
  (cond
   ((windmove-find-other-window 'right) (buf-move-right))
   ((windmove-find-other-window 'left) (buf-move-left))
   ((windmove-find-other-window 'up) (buf-move-up))
   ((windmove-find-other-window 'down) (buf-move-down)))
  (message "switch buffer done"))

(defun buffer-exists (bufname)   
  (not (eq nil (get-buffer bufname))))

(defvar aborn/compile-log-buffer-name "*Compile-Log*")
(defun aborn/save-compile-log-by-date (arg)
  "save each package install *Compile-Log* buffer content"
  (interactive "P")
  (if (not (buffer-exists aborn/compile-log-buffer-name))
      (message "not buffer name *Compile-Log* exists!")
    (progn
      (let* ((current-buffer-save (current-buffer))
             (current-time-stamp-local
              (format-time-string "%Y-%m-%d-%H" (current-time)))
             (compile-log-file-name
              (format "~/.spacemacs.d/local/compile-log-%s.txt" current-time-stamp-local)))
        (save-current-buffer
          (message "*Compile-Log* save to '%s'" compile-log-file-name)
          (set-buffer aborn/compile-log-buffer-name)
          (write-file compile-log-file-name)
          (save-buffer))))))

(defun ab/wrap-temp-buffer-name (buf-name)
  (downcase (if (and (string-suffix-p "*" buf-name)
                     (string-prefix-p "*" buf-name))
                (substring buf-name 1 (- (string-width buf-name) 1))
              buf-name)))

(defun aborn/save-buffer-content-by-date (buf-name)
  (if (not (buffer-exists buf-name))
      (message "warning: not find buffer with name %s" buf-name)
    (progn
      (let* ((current-time-stamp-local
              (format-time-string "%Y-%m-%d-%H" (current-time)))
             (local-save-file-name
              (format "~/.spacemacs.d/local/%s-%s.txt" (ab/wrap-temp-buffer-name buf-name) current-time-stamp-local)))
        (save-current-buffer
          (message "save buffer %s content to %s" buf-name local-save-file-name)
          (set-buffer buf-name)
          (write-file local-save-file-name)
          (save-buffer))))))

(defun aborn/save-message-content ()
  (if (not (buffer-exists "*Messages*"))
      (message "warning: not find buffer with name *Messages*")
    (progn
      (let* ((local-save-file-name "~/.spacemacs.d/local/Messages.txt"))
        (save-current-buffer
          (message "append buffer *Messages* content to %s" local-save-file-name)
          (set-buffer "*Messages*")
          (write-region (decode-coding-string (buffer-string) 'utf-8)
                        nil local-save-file-name 'append)
          ;;(append-to-file (point-min) (point-max) local-save-file-name)
          )))))

(defun aborn/rename-file-and-buffer ()
  "Renames both current buffer and file it's visiting to NEW-NAME."
  ;;(interactive "sNew name: ")
  (interactive)
  (unless (buffer-file-name)
    (error "no visited file for current buffer."))
  (let* ((name (buffer-name))
         (filename (buffer-file-name))
         (ext (file-name-extension filename))
         (old-name (file-name-nondirectory filename))
         (new-name))
    (setq new-name (read-from-minibuffer
                    (format "New name (origin %s): " old-name) old-name ))
    (unless filename
      (error "Buffer '%s' is not visiting a file! Rename failed." name))
    (unless (s-contains? "." new-name)
      (setq new-name (concat new-name "." ext)))
    (when (equal current-prefix-arg '(4))
      (message "insert %% only"))
    (if (get-buffer new-name)
        (progn
          (message "A buffer named '%s' already exists! Use another name!" new-name)
          (rename-file name new-name 1)
          (rename-buffer (concat new-name "#" name))
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (when (listp recentf-list)
            (delete filename recentf-list)))
      (progn
        (rename-file name new-name 1)
        (rename-buffer new-name)
        (set-visited-file-name new-name)
        (set-buffer-modified-p nil)
        (when (listp recentf-list)
          (delete filename recentf-list))))))

(defun aborn/delete-file-and-buffer ()
  "Delete current buffer and its visiting file."
  (let ((filename (buffer-file-name)))
    (when (and filename
               (file-exists-p filename))
      (delete-file filename)
      (when (listp recentf-list)
        (delete filename recentf-list)))
    (when (buffer-exists (current-buffer))
      (kill-buffer))))

(defun aborn/create-file (&optional fname)
  "Create file in current default-directory."
  (interactive)
  (when (null fname)
    (setq fname (read-string (format "New file name in %s: " default-directory))))
  (when (s-blank-str? fname)
    (error "file name can not be empty!"))
  (find-file fname))

(defun aborn/delete-file ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (when (yes-or-no-p
             (format "Do you really want to delete %s?" filename))
        (aborn/delete-file-and-buffer)
        (message "file %s was deleted" filename)
        (when (listp recentf-list)
          (delete filename recentf-list))
        ))))

(defun aborn/copy-selected-content ()
  "copy current selected content"
  (interactive)
  (if mark-active
      (progn
        (kill-new (buffer-substring (mark) (point)))
        (keyboard-quit))
    (progn
      (kill-new (buffer-string))
      (message "yon don't select any content. copy default current buffer content default."))))

(defun aborn/delete-buffer ()
  "remove current buffer from recentf-list and kill it"
  (interactive)
  (let ((name (buffer-file-name)))
    (when (listp recentf-list)
      (delete name recentf-list))
    (kill-buffer)
    (message "buffer:%s was deleted!" name)
    ))

(provide 'aborn-buffer)
;;; aborn-buffer.el ends here
