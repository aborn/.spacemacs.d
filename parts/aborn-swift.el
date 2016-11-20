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

(defun aborn/magit-create-fix-branch ()
  "Crate fix branch using magit."
  (interactive)
  (let* ((cbranch (magit-get-current-branch))
         (bname (format-time-string "fix%m%d" (current-time))))
    (if (and cbranch
             (not (string= cbranch bname))
             (string= "master" cbranch))
        (magit-branch-and-checkout bname "master")
      (message "current branch is %s (not master), create branch %s failed." cbranch bname))
    (force-mode-line-update)))

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

(provide 'aborn-swift)
;;; aborn-swift.el ends here
