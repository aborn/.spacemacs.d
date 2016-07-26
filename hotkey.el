;; personal hot-key

(define-prefix-command 'aborn-prefix-map)
(define-key aborn-prefix-map (kbd "d f") 'aborn/delete-file)
(define-key aborn-prefix-map (kbd "d b") 'aborn/delete-buffer)
(global-set-key "\C-c\C-c" aborn-prefix-map)
