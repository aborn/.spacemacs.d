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
  (message "ab/major-mode-key-binding done!"))

;; define lisp-interaction-mode-map
;; (define-key lisp-interaction-mode-map (kbd "C-j") 'switch-to-buffer)
(define-key lisp-interaction-mode-map (kbd "C-j") 'helm-buffers-list)
(define-key lisp-interaction-mode-map (kbd "C-x j") 'eval-print-last-sexp)

;; define emacs-lisp-mode-map
(define-key emacs-lisp-mode-map (kbd "C-x j") 'eval-region)
(define-key emacs-lisp-mode-map (kbd "C-x SPC")  'ace-jump-mode)
;;(add-hook emacs-lisp-mode-hook 'yas-minor-mode)

;; define scheme-mode-map 
(define-key scheme-mode-map (kbd "C-x j") 'xscheme-send-buffer)

;; define shell-mode-map
(define-key shell-mode-map (kbd "C-x SPC")  'ace-jump-mode)
(define-key shell-mode-map (kbd "C-c SPC")  'ace-jump-mode)

;; define matlab-shell--mode-map
;; (require 'matlab-shell-mode)
;; NOTE, the initial matlab-shell-mode-map can't be nil (empty)
(unless matlab-shell-mode-map
  (setq matlab-shell-mode-map (make-sparse-keymap))
  (define-key matlab-shell-mode-map (kbd "C-c SPC")  'ace-jump-mode)
  (define-key matlab-shell-mode-map (kbd "C-x SPC")  'ace-jump-mode)
  (define-key matlab-shell-mode-map (kbd "RET") 'comint-send-input)
  (define-key matlab-shell-mode-map (kbd "C-c C-c") 'comint-interrupt-subjob)
  (define-key matlab-shell-mode-map (kbd "M-p") 'comint-previous-input)
  (define-key matlab-shell-mode-map (kbd "M-n") 'comint-next-input)
  )

;; define geiser-repl-mode-map
;;(define-key geiser-repl-mode-map (kbd "C-j") 'switch-to-buffer)

;; ielm hook key-bindings.
(add-hook 'inferior-emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") 'helm-buffers-list)))
(add-hook 'ielm-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") 'helm-buffers-list)
            (local-set-key (kbd "M-n") 'ace-jump-mode)))

;; define the latex-mode and bibtex-mode
;; define latex-mode-map local binding
;;(define-key latex-mode-map (kbd "C-j")  'switch-to-buffer)
;; (eval-after-load 'latex
;;   '(define-key LaTeX-mode-map 
;;      (kbd "C-x j")  'ab/latex-compile-current-file))
;;(define-key latex-mode-map (kbd "C-c i")  'ab/latex-insert-marker)
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c i")  'ab/latex-insert-marker)
            (local-set-key (kbd "C-x j")  'ab/latex-compile-current-file)))

;; (add-hook 'LaTeX-mode-hook
;;           (lambda () 
;;             (local-set-key (kbd "C-j") 'switch-to-buffer)
;;             (local-set-key (kbd "C-x j") 'ab/latex-compile-current-file)))

;;define bibtex-mode-hook
(add-hook 'bibtex-mode-hook
          (lambda ()
            (local-set-key (kbd "C-j") 'switch-to-buffer)
            (local-set-key (kbd "C-x j") 'ab/latex-add-ref)))

;; add racket mode
;;(add-hook 'racket-mode-hook 'yas-minor-mode)

(add-hook 'js2-mode-hook 'ab/major-mode-key-binding)
(add-hook 'markdown-mode-hook 'ab/major-mode-key-binding)
(add-hook 'compilation-mode-hook 'ab/major-mode-key-binding)
(add-hook 'text-mode-hook 'ab/major-mode-key-binding) ;; add auctex mode
(add-hook 'sh-mode-hook 'ab/major-mode-key-binding)

(add-hook 'messages-buffer-mode-hook 'ab/major-mode-key-binding)
(add-hook 'term-mode-hook 'ab/major-mode-key-binding)
(add-hook 'term-exec-hook
          (lambda ()
            (define-key term-raw-map (kbd "M-n") 'ace-jump-mode)
            (message "term-exec-hook exected!")
            (local-set-key (kbd "M-n") 'ace-jump-mode)))
(define-key term-raw-map (kbd "M-n") 'ace-jump-mode)  ;; 直接修改它的key-map有用
