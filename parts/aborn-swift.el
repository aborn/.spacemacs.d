;; some swift action
(defun aborn/swift-git-commit-push (message)
  "commit modified and push to upstream"
  (interactive "sCommit Message: ")
  (when (null message)
    (setq message (read-string "your message: " nil nil "update")))
  (message "your message is %s" message)
  (save-buffer)
  (magit-stage-modified)
  (magit-commit (list "-m" message))
  (aborn/timer-task-delay-excute-once
   10       ;; 延时10s执行 git push操作
   (lambda ()
     (call-interactively #'magit-push-current-to-upstream))))

(provide 'aborn-swift)
