(provide 'major-mode-binding)
;; --------------------------------------------------------------------
;; provide local each major mode key binding
;; each local major-mode key binding 主mode下的键绑定
;; 绑定在所有模式都统一的一些全局快捷键
;; --------------------------------------------------------------------

(defun ab/major-mode-key-binding ()
  (interactive)
  (local-set-key (kbd "M-n") 'ace-jump-mode)
  (local-set-key (kbd "C-j") 'helm-buffers-list)
  (local-set-key (kbd "C-o") 'other-window)
  (local-set-key (kbd "M-j") 'helm-find-files)
  (local-set-key (kbd "C-x j") 'ab/run-current-file)
  (local-set-key (kbd "C-;") 'move-forward-by-five)
  (local-set-key (kbd "C-:") 'move-backward-by-five)
  (flyspell-mode-off)      ;; 跟快捷键 C-; 有冲突，暂时关闭
  (message "ab/major-mode-key-binding done!"))

;; define lisp-interaction-mode-map
(define-key lisp-interaction-mode-map (kbd "C-j") 'helm-buffers-list)
(define-key lisp-interaction-mode-map (kbd "C-x j") 'eval-print-last-sexp)

;; define emacs-lisp-mode-map
(define-key emacs-lisp-mode-map (kbd "C-x j") 'eval-region)
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (flyspell-mode-off)
            (message "turn off flyspell mode")))

;; ielm hook key-bindings.
(add-hook 'inferior-emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") 'helm-buffers-list)))
(add-hook 'ielm-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") 'helm-buffers-list)
            (local-set-key (kbd "M-n") 'ace-jump-mode)))

(add-hook 'js2-mode-hook 'ab/major-mode-key-binding)
(add-hook 'markdown-mode-hook 'ab/major-mode-key-binding)
(add-hook 'compilation-mode-hook 'ab/major-mode-key-binding)
(add-hook 'text-mode-hook 'ab/major-mode-key-binding) ;; add auctex mode
(add-hook 'sh-mode-hook 'ab/major-mode-key-binding)
(add-hook 'messages-buffer-mode-hook 'ab/major-mode-key-binding)
