;;; aborn-core.el --- Aborn's core package

;; Copyright (C) 2016 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; This file is not part of GNU Emacs.

;;; Code:

(defgroup aborn nil
  "aborn package group"
  :prefix "aborn-"
  :group 'convenience)

(defun aborn/push-marker-stack ()
  "Push marker to stack."
  (if (fboundp 'xref-push-marker-stack)
      (xref-push-marker-stack)
    (with-no-warnings
      (ring-insert find-tag-marker-ring (point-marker)))))

(provide 'aborn-core)
;;; aborn-core.el ends here
