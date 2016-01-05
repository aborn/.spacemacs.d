;; -----------------------------------------------------------------------------
;; quick-file-jump.el
;; Why this module?
;;     Sometimes, we need to open a file or buffer which name 
;;            began with current word in emacs.
;;     Here is the solution.
;;
;; Install.
;;   put this file (quick-file-jump.el) in your load path and
;;   add follow codes into your initial emacs files (.emacs or init.el)
;;   (require 'quick-file-jump)
;;   (global-set-key (kbd "<M-return>") 'ab/quick-buffer-jump)
;;
;; Author:
;;   Aborn Jiang (aborn.jiang@foxmail.com)
;; 
;; Version
;;   v0.1 2014-05-13
;; -----------------------------------------------------------------------------

(provide 'quick-file-jump)
(defun ab/quick-buffer-jump ()
  "Quickly jump to buffer/file which name is current word"
  (interactive)
  (setq fname (current-word))
  (setq blist (buffer-list))
  (setq status nil)
  (setq switchedbuffer "nil")
  (dolist (value blist)
    (when (and (bufferp value)
               (buffer-file-name value)
               (not status)
               (string-match (concat "^" (regexp-quote fname))
                             (buffer-name value)))
      (progn (switch-to-buffer (buffer-name value))
             (setq status t)
             (setq switchedbuffer (buffer-name value)))
      ))
  (if status                     ;; success search in buffer list.
      (message "skip to %s buffer" switchedbuffer)
    (ab/quick-file-jump)))       ;; find files in current path.

(defun ab/quick-file-jump ()
  "Quickly open and jump file with name begin with current word"
  (interactive)
  (setq fname (current-word))
  (setq switchedfile "nil")
  (setq dflist (directory-files (ab/get-current-path)))
  (dolist (value dflist)
    (when (and (file-regular-p value)
               (string-match 
                (concat "^" (regexp-quote fname)) value))
      (find-file value)
      (setq switchedfile value)
      (setq status t)))
  (if status                     ;; success search in file list
      (message "open and skip to %s file." switchedfile)
    (message "not find file name begin %s" fname)))

(defun ab/get-current-path ()
  "Get the current path"
  (interactive)
  (message (file-name-directory (buffer-file-name))))

;; default global key setting
(global-set-key (kbd "<M-return>") 'ab/quick-buffer-jump)
