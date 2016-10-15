;; personal hot-key

(define-prefix-command 'aborn-prefix-map)
(define-key aborn-prefix-map (kbd "d f") 'aborn/delete-file)
(define-key aborn-prefix-map (kbd "d b") 'aborn/delete-buffer)
(define-key aborn-prefix-map (kbd "g a") 'aborn/git-code-update)
(define-key aborn-prefix-map (kbd "g u") 'aborn/swift-git-commit-push)
(define-key aborn-prefix-map (kbd "g p") 'magit-git-pull)
(define-key aborn-prefix-map (kbd "f n") 'aborn/copy-file-name-to-clipboard)
(define-key aborn-prefix-map (kbd "j")   'aborn/elisp-function-find)

(global-set-key "\C-c\C-c" aborn-prefix-map)
