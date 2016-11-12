;;;  my-keys-minor-mode.el --- Global key minor mode

;; 强制的全局快捷键绑定
;; 参考:
;; http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs
;; http://emacs.stackexchange.com/questions/352/how-to-override-major-mode-bindings
;;

;; 全局的key-binding放在这里
;; 注意 C-c C-c 这个按键在一些mode(如org-mode, trem-mode)还是很有用的，另覆盖它
(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-o") 'ace-window)
    (define-key map (kbd "C-j") 'helm-buffers-list)
    (define-key map (kbd "M-j") 'aborn/find-file)
    (define-key map (kbd "C-i") 'aborn/just-one-space)
    (define-key map [C-backspace] 'aborn/backward-kill-word)
    (define-key map (kbd "C-;") 'move-forward-by-five)
    (define-key map (kbd "C-:") 'move-backward-by-five)
    (define-key map (kbd "C-'") 'move-middle-of-line)
    (define-key map (kbd "C-s") 'swiper)
    (define-key map (kbd "M-.") 'elisp-slime-nav-find-elisp-thing-at-point)
    (define-key map (kbd "M-,") 'pop-tag-mark)
    (define-key map (kbd "C-M-i") 'complete-symbol)
    (define-key map (kbd "M-n") 'ace-jump-mode)
    (define-key map (kbd "C-x n") 'ace-jump-line-mode)
    (define-key map (kbd "C-c m") 'ace-pinyin-dwim)
    map)
  "my-keys-minor-mode keymap.")

;;;###autoload
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " Ⓖ"
  ;; 区别C-i与TAB http://stackoverflow.com/questions/1792326/how-do-i-bind-a-command-to-c-i-without-changing-tab
  (setq local-function-key-map (delq '(kp-tab . [9]) local-function-key-map)))

(defun my-keys-have-priority (_file)
  "Try to ensure that my keybindings retain priority over other minor modes.
Called via the `after-load-functions' special hook."
  (unless (eq (caar minor-mode-map-alist) 'my-keys-minor-mode)
    (let ((mykeys (assq 'my-keys-minor-mode minor-mode-map-alist)))
      (assq-delete-all 'my-keys-minor-mode minor-mode-map-alist)
      (add-to-list 'minor-mode-map-alist mykeys))))

;; Turn off the minor mode in the minibuffer
(defun my-keys-turn-off ()
  "Turn off my--keys-minor-mode"
  (my-keys-minor-mode -1))

(provide 'my-keys-minor-mode)
;;; my-keys-minor-mode.el ends here
