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
  (magit-push-current-to-upstream)
  ;; (aborn/timer-task-delay-excute-once
  ;;  1       ;; 延时1s执行 git push操作
  ;;  (lambda ()
  ;;    (call-interactively #'magit-push-current-to-upstream)))
  )

(provide 'aborn-swift)
