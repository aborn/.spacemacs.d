;;; aborn-swift.el --- some swift actions.

;; Copyright (C) 2016  Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((async "1.9"))
;; Keywords: emacs cookbook
;; URL: https://github.com/aborn/.spacemacs.d

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; some swift action

;;; Code:

(require 'async)

(defun aborn/magit-create-or-checkout-fix-branch ()
  "Crate (or checkout to) fix branch using magit."
  (interactive)
  (let* ((cbranch (magit-get-current-branch))
         (bname (format-time-string "fix%m%d" (current-time))))
    (if (member bname (magit-list-local-branch-names))
        (progn
          (magit-checkout bname)
          (message "checkout to branch %s success." bname)
          (force-mode-line-update))
      (if (and cbranch
               (not (string= cbranch bname))
               (string= "master" cbranch))
          (progn
            (magit-branch-and-checkout bname "master")
            (message "create & checkout to branch %s success." bname))
        (message "current branch is %s (not master), create branch %s failed." cbranch bname))
      (force-mode-line-update))))

(defun aborn/swift-git-commit-push (msg)
  "Commit modified and push to upstream."
  (interactive "sCommit Message: ")
  (when (= 0 (length msg))
    (setq msg (format-time-string "commit by magit in emacs@%Y-%m-%d %H:%M:%S" (current-time))))
  (message "commit message is %s" msg)
  (when (and buffer-file-name
             (buffer-modified-p))
    (save-buffer))                                     ;; save it first if modified.
  (magit-stage-modified)
  (magit-commit (list "-m" msg))
  (let* ((begin-time (current-time)))
    (async-start
     `(lambda ()
        ,(async-inject-variables "\\`begin-time\\'")
        ,(async-inject-variables "\\`default-directory\\'")
        ,(async-inject-variables "\\`load-path\\'")    ;; main-process load-path.
        (require 'magit)
        (require 'aborn-log)
        (aborn/log (format "[[** start to execute push in directory %s" default-directory))
        (aborn/log (shell-command-to-string "echo $PWD"))
        (when (file-exists-p default-directory)
          (aborn/log (shell-command-to-string "git push"))
          (aborn/log "finished push. **]]"))
        (format "%s push to upstream success. %s. time cost: %ss."
                (aborn/log-format "")
                (or (magit-get "remote" "origin" "url") default-directory)
                (float-time (time-subtract (current-time) begin-time))))
     (lambda (result)
       (message "%s" result)))))

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

(provide 'aborn-swift)
;;; aborn-swift.el ends here
