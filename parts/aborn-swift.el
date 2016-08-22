;; some swift action
(defun aborn/swift-git-commit-push (msg)
  "commit modified and push to upstream"
  (interactive "sCommit Message: ")
  (when (= 0 (length msg))
    (setq msg (format-time-string "update@%Y-%m-%d %H:%M:%S" (current-time))))
  (message "commit message is %s" msg)
  (save-buffer)
  (magit-stage-modified)
  (magit-commit (list "-m" msg))
  (async-start
   `(lambda ()
      ,(async-inject-variables "\\`default-directory\\'")
      ,(async-inject-variables "\\`load-path\\'") ;; add main process load-path
      (require 'aborn-timer-task)
      (require 'magit)
      (require 'aborn-log)
      (aborn/log (format "** start to execute push in directory %s" default-directory))
      (aborn/log (shell-command-to-string "echo $PWD"))
      (when (file-exists-p default-directory)
        (aborn/log (shell-command-to-string "git push"))
        (aborn/log "finished push. **"))
      ;; (aborn/timer-task-delay-excute-once
      ;;  1       ;; 延时1s执行 git push操作
      ;;  (lambda ()
      ;;    (call-interactively #'magit-push-current-to-upstream)))
      default-directory)
   (lambda (result)
     (message "push to upstream success. %s" result))
   ))

(provide 'aborn-swift)
