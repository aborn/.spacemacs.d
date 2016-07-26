;; personal hot-key

(define-prefix-command 'aborn-prefix-map)
(define-key aborn-prefix-map (kbd "d") 'aborn/delete-file)
(global-set-key "\C-c\C-n" aborn-prefix-map)

;;(global-set-key "\C-c\C-nd" 'aborn/delete-file)
(message "aborn-hotkey....")
