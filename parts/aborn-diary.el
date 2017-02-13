;;; aborn-diary.el --- Aborn' diary package

;; Copyright (C) 2016-2017 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; This file is not part of GNU Emacs.

;;; Code:


(defun aborn/diary-create ()
  (interactive)
  (let* ((date-name (format-time-string "%Y-%m-%d.org" (current-time)))
         file-name)
    (setq file-name (read-from-minibuffer
                     (format "Diary name (default %s): " date-name) date-name ))
    (message "diary name=%s" file-name)
    ))

(provide 'aborn-diary)
;;; aborn-diary.el ends here
