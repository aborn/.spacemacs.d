;; --------------------------------------------------------------------
;; provide all global key bindings 
;; global hot key (key binding) setting all together 
;; common key
;; "\C-" "\M-" TAB, RET, ESC, DEL "\t" "\r" "\e"
;; --------------------------------------------------------------------

;; symbol related
(global-set-key (kbd "C-*") 'flyspell-auto-correct-previous-word)
(global-set-key (kbd "C-(") 'comment-region)
(global-set-key (kbd "C-)") 'uncomment-region)

;; insert-string related
(global-set-key "\C-cd" 'insert-date)
(global-set-key "\C-cD" 'ab/insert-current-time)
(global-set-key "\C-xt" 'ab/insert-current-date-time)
(global-set-key "\C-cm" 'ab/insert-email-address)
(global-set-key "\C-cn" 'ab/insert-name-english)
(global-set-key "\C-cN" 'ab/insert-name-chinese)
(global-set-key "\C-cl" 'ab/switch-buffer-each-other)

;; window-dealing related.
(global-set-key "\C-ch" 'ab/window-layout-default)
(global-set-key "\C-cH" 'ab/window-layout-codeview)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; split window的时候，打开新的buffer
(global-set-key (kbd "C-x 3")
                (lambda ()
                  (interactive)
                  (setq cw (selected-window))
                  (split-window-right)
                  (select-window (next-window))
                  (bury-buffer)
                  (select-window cw)))

(global-set-key (kbd "C-x 2")
                (lambda ()
                  (interactive)
                  (setq cw (selected-window))
                  (split-window-below)
                  (select-window (next-window))
                  (bury-buffer)
                  (select-window cw)))

(provide 'aborn-global-key-binding)
