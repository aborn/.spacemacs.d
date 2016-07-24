;; some swift action

(defun aborn/swift-git-commit-push (&optional commit)
  "commit and push"
  (interactive)
  (when (null commit)
    (setq commit (read-string "your commit: " nil nil "update")))
  (message "your commit is %s" commit)
  )

(provide 'aborn-swift)
