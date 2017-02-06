;;; aborn-core.el --- Aborn's core package

;; Copyright (C) 2016-2017 Aborn Jiang

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

(defun aborn/pop-tag-mark ()
  "Rewrite pop-tag-mark alias xref-pop-marker-stack to fix multi-window back.
   Pop back to where \\[xref-find-definitions] was last invoked."
  (interactive)
  (unless (boundp 'ggtags-mode)
    (spacemacs/ggtags-mode-enable))   ;; 开启 ggtags-mode
  (let ((ring xref--marker-ring))
    (when (ring-empty-p ring)
      (user-error "Marker stack is empty"))
    (let* ((marker (ring-remove ring 0))
           (mbuffer (or (marker-buffer marker)
                        (user-error "The marked buffer has been deleted")))
           (mwindow (get-buffer-window mbuffer)))
      (when mwindow
        (select-window mwindow))
      (switch-to-buffer mbuffer)
      (goto-char (marker-position marker))
      (set-marker marker nil nil)
      (run-hooks 'xref-after-return-hook))))

(defun aborn/nav-thing-at-point (sym-name)
  "Nav to adopt position in different mode-line"
  )

(provide 'aborn-core)
;;; aborn-core.el ends here
