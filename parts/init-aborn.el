(spacemacs/toggle-maximize-frame)          ;; 初始化后，最大化窗口
(when (string= system-type "darwin")       ;; mac系统用command代替alter作为键
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta))

;; --------------------------------------------------------------------
;; 最基本的全局快捷键
;; 和全局require
;; --------------------------------------------------------------------
(global-set-key "\C-o" 'other-window)
(global-set-key (kbd "C-j") 'helm-buffers-list)
(global-set-key (kbd "M-j") 'helm-find-files)

(require 'move-swift)
(require 'basic-key-binding)           ;; 基本的快捷键设置
(require 'major-mode-binding)          ;; local major mode key binding
(require 'package-part)
(require 'init-helm-aborn)

;; 基本设置
(require 'hl-line)                  ; highlight current line
(global-hl-line-mode t)             ; setting as global hl
(setq x-select-enable-clipboard t)  ; copy and paste with other program
(show-paren-mode t)                 ; paren match show
(column-number-mode t)              ; show column number
(global-linum-mode t)               ; show line number

;; 开启 ace-jump-mode
(require 'ace-jump-mode)
(global-set-key (kbd "M-n") 'ace-jump-mode)
(define-key global-map (kbd "C-x n") 'ace-jump-char-mode)
(define-key global-map (kbd "C-x N") 'ace-jump-line-mode)

(require 'ace-jump-helm-line)
(eval-after-load "helm"
  '(define-key helm-map (kbd "M-n") 'ace-jump-helm-line))
(setq ace-jump-helm-line-use-avy-style nil)
 (setq ace-pinyin-use-avy nil)
(ace-pinyin-global-mode)   ;; 开启ace-pinyin mode

(provide 'init-aborn)
