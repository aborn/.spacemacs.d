;;; aborn-global-key-binding.el  --- Aborn global key binding.

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
(global-set-key (kbd "C-c d") 'aborn/insert-date)
(global-set-key "\C-xt" 'ab/insert-current-date-time)
(global-set-key "\C-cn" 'ab/insert-name-english)
(global-set-key "\C-cN" 'ab/insert-name-chinese)
(global-set-key "\C-cl" 'aborn/switch-buffer-each-other)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; highlight-symbol
(global-set-key (kbd "<C-return>") 'highlight-symbol-at-point)
(global-set-key (kbd "C-x C-SPC") 'highlight-symbol-mode)

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

(global-set-key (kbd "C-c w")
                'aborn/copy-selected-content)

(global-set-key [remap kill-ring-save] 'easy-kill)

(spacemacs/set-leader-keys "gd" 'magit-diff)
(spacemacs/set-leader-keys "gp" 'aborn/swift-git-commit-push)

(provide 'aborn-global-key-binding)
;;; aborn-global-key-binding.el ends here
