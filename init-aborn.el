;; -----------------------------------------------------------------------------
;; spacemacs 的个人配置及键绑定
;; by Aborn Jiang (aborn.jiang AT foxmail.com)
;; project: https://github.com/aborn/.spacemacs.d
;; -----------------------------------------------------------------------------
(spacemacs/toggle-maximize-frame)          ;; 初始化后，最大化窗口
(when (string= system-type "darwin")       ;; mac系统用command代替alter作为键
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta))

;; -----------------------------------------------------------------------------
;; 最基本的全局快捷键
;; 和全局require
;; -----------------------------------------------------------------------------
(global-set-key "\C-o" 'other-window)
(global-set-key (kbd "C-j") 'helm-buffers-list)
(global-set-key (kbd "M-j") 'helm-find-files)

(require 'move-swift)
(require 'basic-key-binding)           ;; 基本的快捷键设置
(require 'major-mode-binding)          ;; local major mode key binding
(require 'package-part)
(require 'emacs-nifty-tricks)
(require 'copy-line)
(require 'buffer-dealing)
(require 'window-dealing)
(require 'init-helm-aborn)
(require 'insert-string)               ;; 插入基本字符串
(require 'multi-term-config)
(require 'global-key-binding)          ;; 全局的快捷键绑定

;; -----------------------------------------------------------------------------
;; 基本设置
;; -----------------------------------------------------------------------------
(require 'hl-line)                  ; highlight current line
(global-hl-line-mode t)             ; setting as global hl
(setq x-select-enable-clipboard t)  ; copy and paste with other program
(show-paren-mode t)                 ; paren match show
(column-number-mode t)              ; show column number
(global-linum-mode t)               ; show line number

;; -----------------------------------------------------------------------------
;; 开启 ace-jump-mode
;; -----------------------------------------------------------------------------
(require 'ace-jump-mode)
(global-set-key (kbd "M-n") 'ace-jump-mode)
(define-key global-map (kbd "C-x n") 'ace-jump-char-mode)
(define-key global-map (kbd "C-x N") 'ace-jump-line-mode)

(require 'ace-jump-helm-line)
(eval-after-load "helm"
  '(define-key helm-map (kbd "M-n") 'ace-jump-helm-line))
(setq ace-jump-helm-line-use-avy-style nil)
(setq ace-pinyin-use-avy nil)
(ace-pinyin-global-mode)

;; -----------------------------------------------------------------------------
;; By an unknown contributor, move-cursor to matched bracket
;; The hot-key binding to % 快速移动到匹配到的括号
;; (%%%)
;; -----------------------------------------------------------------------------
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %.
  If position just right in middle of (), only insert %."
  (interactive "P")
  (when (equal current-prefix-arg '(4))
    (message "insert %% only"))
  (cond
   ((equal current-prefix-arg '(4)) (self-insert-command 1))
   ((and (char-equal (char-after) ?])
    (char-equal (char-before) ?[)) (self-insert-command (or arg 1)))
   ((and (char-equal (char-after) ?\))
         (char-equal (char-before) ?\()) (self-insert-command (or arg 1)))
   ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
   ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
   (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'match-paren)

;; -----------------------------------------------------------------------------
;; column-marker.el and fill-column-indicator.el setting
;; hot key: C-x m      unset C-u C-x m
;; 列标记模式
;; -----------------------------------------------------------------------------
(require 'column-marker)
(add-hook 'foo-mode-hook (lambda () (interactive) (column-marker-1 80)))
(global-set-key [?\C-x ?m] 'column-marker-3)
(require 'fill-column-indicator)
(setq fci-rule-width 2)
(setq fci-rule-color "yellow")
(setq fci-rule-column 80)
(define-globalized-minor-mode
  global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;; -----------------------------------------------------------------------------
;; set markdown-mode download from
;;                    http://jblevins.org/projects/markdown-mode/
;; -----------------------------------------------------------------------------
(load-file "~/.spacemacs.d/modules/markdown-mode.el")
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; -----------------------------------------------------------------------------
;; some config-part
;; 注意： elixir语言mode
;;       需要通过elpa安装alchemist和alchemist
;; -----------------------------------------------------------------------------
;; major mode key binding
(require 'major-mode-binding)            ; local major mode key binding
(require 'elixir-part)
;;(require 'init-pkg-aborn)
;;(require 'c-lang-part)
;;(require 'pkg-server)
(require 'web-part)
(require 'ace-jump-helm-line)
(require 'web-utils)
(require 'search-buffers)
(require 'org-mode-part)
(require 'ivy-parts)
(require 'org-page-part)

;; (ab/list-packages)             ;; 异步打开下软件源
(add-hook 'after-init-hook
          (lambda ()
            (load-file helm-adaptive-history-file)))

(setq debug-function-file "~/.emacs.d/debug-function.el")
(when (file-readable-p debug-function-file)
  (load-file debug-function-file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; last update by Aborn Jiang (aborn.jiang@foxmail.com) at 2016-01-06
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
