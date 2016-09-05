;; -----------------------------------------------------------------------------
;; spacemacs 的个人配置及键绑定
;; by Aborn Jiang (aborn.jiang AT foxmail.com)
;; project: https://github.com/aborn/.spacemacs.d
;; -----------------------------------------------------------------------------
(aborn/log "aborn's emacs start to init...")
(require 'cl-lib)
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

(require 'move-swift)                      ;; 快速移动
(require 'aborn-basic-key-binding)         ;; 基本的快捷键设置
(require 'aborn-global-key-binding)        ;; 全局的快捷键绑定
(require 'aborn-major-mode-binding)        ;; local major mode key binding
(require 'package-part)
(require 'emacs-nifty-tricks)
(require 'copy-line)
(require 'aborn-buffer)
(require 'window-dealing)
(require 'init-helm-aborn)
(require 'insert-string)                   ;; 插入基本字符串
(require 'multi-term-config)
(add-to-list 'ivy-sort-functions-alist
             '(t . nil))                   ;; 不要按字符串排序，使用默认排序

;; -----------------------------------------------------------------------------
;; parts 部分，自己写的一些函数，在parts/目录
;; -----------------------------------------------------------------------------
(require 'aborn-async-action)
(require 'aborn-persistent)
(require 'aborn-swift)
(require 'aborn-gtd)
(require 'aborn-utils)
(require 'aborn-face)
(global-set-key "\C-i" 'aborn/just-one-space)

;; -----------------------------------------------------------------------------
;; 基本设置
;; -----------------------------------------------------------------------------
(require 'hl-line)                         ;; 高亮当前行
(global-hl-line-mode t)                    ;; setting as global hl
(setq x-select-enable-clipboard t)         ;; copy and paste with other program
(show-paren-mode t)                        ;; paren match show
(column-number-mode t)                     ;; show column number
;; (global-linum-mode t)                   ;; 显示行号
(electric-pair-mode 1)                     ;; 自动插入右括号{}()[]等
(delete-selection-mode 1)                  ;; yank into selected
(tool-bar-mode -1)                         ;; 关闭toobar
(setq
 dotspacemacs-auto-save-file-location
 'original)                                ;; 自动保存到原文件auto-save
(setq-default dotspacemacs-smartparens-strict-mode t)
(setq ws-butler-mode nil)                  ;; 保存的时候，不要删除最后的空格
(prefer-coding-system 'utf-8)
(beacon-mode 1)                            ;; 再也不用担心鼠标在哪了
(setq beacon-blink-when-focused t)
(setq show-paren-style 'expression)        ;; 高亮括号内内容
;;(set-face-background 'hl-line "#3e4446") ;; 设置高亮当前行的颜色
;;(set-face-foreground 'highlight nil)

;; -----------------------------------------------------------------------------
;; color-layer setting 
;; -----------------------------------------------------------------------------
(setq-default dotspacemacs-configuration-layers
              '((colors :variables colors-enable-rainbow-identifiers t)))
(setq-default dotspacemacs-configuration-layers
              '((colors :variables colors-enable-nyan-cat-progress-bar t)))

;; -----------------------------------------------------------------------------
;; 字体大小设置：
;; 前提条件：Source Code Pro 这种字体在你电脑里已经安装了！
;; https://github.com/adobe-fonts/source-code-pro
;; mac osx用户将.otf文件拷贝到 ~/Library/Fonts/ 即可
;; -----------------------------------------------------------------------------
(setq-default dotspacemacs-default-font '("Source Code Pro"
                                          :size 15
                                          :weight normal
                                          :width normal
                                          :powerline-scale 1.1))

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
  (let ((charafter (char-after)))
    (if charafter
        (cond
         ((equal current-prefix-arg '(4)) (self-insert-command 1))
         ((and (char-equal (char-after) ?])
          (char-equal (char-before) ?[)) (self-insert-command (or arg 1)))
         ((and (char-equal (char-after) ?\))
               (char-equal (char-before) ?\()) (self-insert-command (or arg 1)))
         ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
         ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
         (t (self-insert-command (or arg 1))))
      (self-insert-command 1))))
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
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; -----------------------------------------------------------------------------
;; some config-part
;; 注意： elixir语言mode
;;       需要通过elpa安装alchemist和alchemist
;; -----------------------------------------------------------------------------
(require 'elixir-part)
;;(require 'init-pkg-aborn)
;;(require 'c-lang-part)
;;(require 'pkg-server)
(require 'web-part)
(require 'ace-jump-helm-line)
(require 'web-utils)
(require 'search-buffers)
(require 'aborn-org)
(require 'ivy-parts)
(require 'counsel)

;; (ab/list-packages)                      ;; 异步打开下软件源
(add-hook 'after-init-hook
          (lambda ()
            (load-file helm-adaptive-history-file)))

(setq debug-function-file "~/.emacs.d/debug-function.el")
(when (file-readable-p debug-function-file)
  (load-file debug-function-file))

;; turn off ws-butler-mode                 ;; 关闭强制删除行末空格功能
(ws-butler-global-mode -1)
(message "open emacs finished!")

;; pelpa-mode load
(let ((pelpa-mode-file "~/github/pelpa-mode/pelpa-mode.el"))
  (when (file-exists-p pelpa-mode-file)
    (load-file pelpa-mode-file)
    (require 'pelpa-mode)))

(ensure-package-installed 'tree-mode)
(load-file "~/.spacemacs.d/modules/reddit.el")
(require 'reddit)

(global-disable-mouse-mode)
;; load cip mode if exists.
(let ((cip-mode-code-file "~/github/cip-mode/cip-mode.el"))
  (when (file-exists-p cip-mode-code-file)
    (load-file cip-mode-code-file)
    (require 'cip-mode)))

(setq wttrin-default-cities '("Shanghai"))
(defun ab/shell-command-to-string (command)
  (replace-regexp-in-string "\r?\n$" ""    ;; 去掉换行符号
                            (shell-command-to-string command)))

;; 当emacs退出时，执行这个函数
(defun aborn/exec-when-emacs-kill ()
  (message "exec some operationi when kill emacs")
  (ab/save-message-content)
  (message "now emacs exit!"))

(add-hook 'after-init-hook
          (lambda ()
            (message "after-init-hook")))
(add-hook 'kill-emacs-hook 'aborn/exec-when-emacs-kill)

;; develop && test v2ex-mode
;; (add-to-list 'load-path "~/github/v2ex-mode/")
;; (load "v2ex-mode")
;; develop && test leanote-mode
;; (add-to-list 'load-path "~/github/leanote-mode/")
;; (require 'leanote)

(when (file-directory-p "~/github/emacs-neotree/")
  (add-to-list 'load-path "~/github/emacs-neotree/")
  (require 'neotree))

(setq leanote-user-email "aborn@aborn.me")
(add-hook 'markdown-mode-hook
          (lambda ()
            (leanote)
            (leanote-spaceline-status)  ;; optional, use it if necessary
            ))

;; 下面是一些定时任务
(require 'aborn-timer-task)
(aborn/timer-task-each-8hour 'aborn/git-code-update)
(aborn/log "aborn's emacs have successful finished initialization!")

;; 下面是deft的配置
(setq deft-extensions '("txt" "text" "md" "markdown" "org"))
(setq deft-directory "~/github/eden")
(setq deft-recursive t)
(global-set-key [f8] 'deft)

;; https://github.com/Fanael/highlight-defined
(add-hook 'emacs-lisp-mode-hook 'highlight-defined-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; last update by Aborn Jiang (aborn@aborn.me) at 2016-09-04
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
