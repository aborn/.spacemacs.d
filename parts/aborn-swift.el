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
  (let (exec-path-current)
    (setq exec-path-current default-directory)
    (async-start
     `(lambda ()
        (setq default-directory ,exec-path-current)
        ,(async-inject-variables "\\`load-path\\'") ;; add main process load-path
        (require 'aborn-timer-task)
        (require 'aborn-log)
        (aborn/log (format "exec push in %s" default-directory))
        (aborn/timer-task-delay-excute-once
         1       ;; 延时1s执行 git push操作
         (lambda ()
           (call-interactively #'magit-push-current-to-upstream))))
     (lambda (result)
       (message "push to upstream success. %s:%s" exec-path-current result))
     )))

(provide 'aborn-swift)
