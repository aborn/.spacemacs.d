;;; aborn-diary.el --- Aborn' diary package

;; Copyright (C) 2016-2017 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; This file is not part of GNU Emacs.

;;; Code:


(defcustom aborn/diary-root-path "~/github/diary"
  "Root diary path"
  :group 'aborn
  :type 'string)

(defun aborn/diary-header-content ()
  (concat
   (format "#+TITLE: %s\n" (format-time-string "%Y-%m-%d"))
   "#+AUTHOR: aborn\n"
   (format "#+DATE: %s\n" (format-time-string "%Y-%m-%d %H:%M" (current-time)))
   "#+EMAIL: aborn.jiang@gmail.com\n"
   "#+LANGUAGE: zh\n"
   "#+LATEX_HEADER: \\usepackage{xeCJK}\n\n"
   "#+SETUPFILE: ~/github/org-html-themes/setup/theme-readtheorg.setup\n\n"
   "-----\n"))

(defun aborn/diary-create ()
  (interactive)
  (let* ((date-name (format-time-string "%Y-%m-%d.org" (current-time)))
         file-name)
    (setq file-name (read-from-minibuffer
                     (format "Diary name (default %s): " date-name) date-name ))
    (setq file-name (expand-file-name file-name aborn/diary-root-path))
    (find-file file-name)
    (unless (file-exists-p file-name)
      (insert (aborn/diary-header-content)))
    ;;(save-buffer)
    (message "diary name=%s" file-name)
    ))

(provide 'aborn-diary)
;;; aborn-diary.el ends here
