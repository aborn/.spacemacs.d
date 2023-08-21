(require 'run-scripts)

;; --------------------------------------------------------------------
;; provide local each major mode key binding
;; each local major-mode key binding 主mode下的键绑定
;; 绑定在所有模式都统一的一些全局快捷键
;; --------------------------------------------------------------------

(defun aborn/major-mode-key-binding ()
  (interactive)
  (local-set-key (kbd "M-n") 'ace-jump-mode)
  (local-set-key (kbd "C-j") 'helm-buffers-list)
  ;;(local-set-key (kbd "C-j") 'ido-switch-buffer)
  (local-set-key (kbd "C-o") 'other-window)
  (local-set-key (kbd "M-j") 'ido-find-file)
  ;;(local-set-key (kbd "M-j") 'helm-find-files)
  (local-set-key (kbd "C-x j") 'aborn/run-current-file)
  (local-set-key (kbd "C-;") 'move-forward-by-five)
  (local-set-key (kbd "C-:") 'move-backward-by-five)
  (flyspell-mode-off)      ;; 跟快捷键 C-; 有冲突，暂时关闭
  )

;; define lisp-interaction-mode-map
(define-key lisp-interaction-mode-map (kbd "C-j") 'helm-buffers-list)
(define-key lisp-interaction-mode-map (kbd "C-x j") 'eval-print-last-sexp)

(define-key flyspell-mode-map (kbd "C-;") 'move-forward-by-five)
;; (define-key js2-mode-map (kbd "M-j") 'ido-find-file)

;; define emacs-lisp-mode-map
(defun aborn/major-mode-binding-elisp-run ()
  "eval-region & keyboard-quit"
  (interactive)
  (when mark-active
    (eval-region (region-beginning) (region-end))
    (keyboard-quit)
    (message "finish eval-region.")))

;; (define-key emacs-lisp-mode-map (kbd "C-x j") 'aborn/major-mode-binding-elisp-run)
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (flyspell-mode-off)
            (local-set-key (kbd "C-j") 'helm-buffers-list)
            (local-set-key (kbd "C-x j") 'aborn/major-mode-binding-elisp-run)
            ;;(local-set-key (kbd "C-j") 'ido-switch-buffer)
            (message "turn off flyspell mode in elisp!")))

;; ielm hook key-bindings.
(add-hook 'inferior-emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") 'helm-buffers-list)))
(add-hook 'ielm-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") 'helm-buffers-list)
            (local-set-key (kbd "M-n") 'ace-jump-mode)))

(add-hook 'js2-mode-hook 'aborn/major-mode-key-binding)
(add-hook 'web-mode-hook 'aborn/major-mode-key-binding)
(add-hook 'markdown-mode-hook 'aborn/major-mode-key-binding)
(add-hook 'compilation-mode-hook 'aborn/major-mode-key-binding)
(add-hook 'text-mode-hook 'aborn/major-mode-key-binding) ;; add auctex mode
(add-hook 'sh-mode-hook 'aborn/major-mode-key-binding)
(add-hook 'messages-buffer-mode-hook 'aborn/major-mode-key-binding)
(add-hook 'term-mode-hook 'aborn/major-mode-key-binding)
(add-hook 'makefile-bsdmake-mode-hook (lambda ()
                                        (local-set-key (kbd "M-n" 'ace-jump-mode))))
(add-hook 'makefile-mode-hook
          (lambda ()
            (define-key makefile-browser-map (kbd "C-j") 'helm-buffers-list)
            (local-set-key (kbd "M-n" 'ace-jump-mode))))

;; 对某个minor-mode 的keymap进行改键
(add-hook 'web-mode-hook
          (lambda ()
            ;; (define-key emmet-mode-keymap (kbd "C-j") 'helm-buffer-list)
            (define-key web-mode-map (kbd "C-j") 'helm-buffer-list)))

(provide 'aborn-major-mode-binding)
