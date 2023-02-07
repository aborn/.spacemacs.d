;; -----------------------------------------------------------------------------
;; Aborn's Spacemacs Configurations.
;; by Aborn Jiang (aborn.jiang AT foxmail.com)
;; project: https://github.com/aborn/.spacemacs.d
;; -----------------------------------------------------------------------------
(message "------------------------------------------------------")
(aborn/log "aborn's emacs start to init...")
(message "aborn's emacs start to init...")

(require 'f)
(require 's)
(require 'cl-lib)

(spacemacs/toggle-maximize-frame)          ;; 初始化后，最大化窗口
(when (string= system-type "darwin")       ;; macOS系统用command代替alter作为M键
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta)
  (setq dired-use-ls-dired nil))           ;; macOS系统的ls不支持--dired这个option

;; -----------------------------------------------------------------------------
;; 最基本的全局load及features require
;; -----------------------------------------------------------------------------
(slpp-load-path-and-pkgs
 '(("~/github/emacs-cookbook" "cookbook")
   ("~/.spacemacs.d/hotkey"                ;; 按键相关放在hotkey/目录下
    aborn-basic-key-binding                ;; 基本的快捷键设置
    aborn-global-key-binding               ;; 全局的快捷键绑定
    aborn-major-mode-binding               ;; local major mode key binding
    )
   ("~/.spacemacs.d/parts"                 ;; 自己写的一些函数放在parts/目录下
    move-swift                             ;; 快速移动
    ;; package-part                           ;; 包相关的
    emacs-nifty-tricks
    copy-line                              ;; copy当前行
    aborn-buffer                           ;; buffer相关
    window-dealing                         ;; window相关
    init-helm-aborn                        ;; helm的初始化
    insert-string                          ;; 插入基本字符串
    aborn-async-action
    aborn-persistent                       ;; 持久化存储
    aborn-swift
    aborn-gtd                              ;; getting things done
    aborn-utils                            ;; 工具函数
    aborn-face                             ;; 异步执行的任务
    aborn-org                              ;; org相关配置
    aborn-char                             ;; char相关操作
    aborn-cus                              ;; 一些对系统函数的定制
    aborn-diary                            ;; 日志相关
    aborn-deps                             ;; emacs运行需要的相关依赖
    local-config
    )
   ;;; 下面是aborn自己需要加载的一些mode
   ("~/github/multi-term-plus" multi-term-config)
   ("~/github/pelpa-mode" pelpa-mode)
   ("~/github/cip-mode" cip-mode)
   ;; ("~/github/v2ex-mode" v2ex-mode)
   ("~/github/leanote-mode"
    (leanote :after (lambda ()             ;; 本地开发leanote时用
                      (setq leanote-user-email "aborn@aborn.me")
                      (add-hook 'markdown-mode-hook
                                (lambda ()
                                  (leanote)
                                  (leanote-spaceline-status)  ;; optional, use it if necessary
                                  )))))
   ("~/github/emacsist" emacsist)
   ("~/github/emacs-neotree"
    (neotree :before (lambda ()
                       (message "before neotree")
                       ;; 设置按键模式，这种按键比较短
                       (setq neo-keymap-style 'concise))
             :after (lambda () (message "after neotree."))))
   ))
(add-to-list 'ivy-sort-functions-alist
             '(t . nil))                   ;; 不要按字符串排序，使用默认排序

;; -----------------------------------------------------------------------------
;; 基本设置
;; -----------------------------------------------------------------------------
(require 'hl-line)                         ;; 高亮当前行
(global-hl-line-mode t)                    ;; setting as global hl
(if (version<= emacs-version "24.5")
    (setq x-select-enable-clipboard t)     ;; copy and paste with other program
  (setq select-enable-clipboard t))        ;; 25.1 版本改成这个变量了
(show-paren-mode t)                        ;; paren match show
(column-number-mode t)                     ;; show column number
(global-linum-mode t)                      ;; 显示行号
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
(setq show-paren-style 'parenthesis)       ;; 高亮括号内内容 'expression
;;(set-face-background 'hl-line "#3e4446") ;; 设置高亮当前行的颜色
;;(set-face-foreground 'highlight nil)
(setq save-silently t)                     ;; 保存文件时不要询问,直接保存
(setq buffer-save-without-query t)         ;; 调用save-some-buffers不需要询问
(setq pyim-isearch-enable-pinyin-search t)
(setq diredful-init-file "~/.spacemacs.d/diredful-conf.el")
(setq ispell-program-name
      "/usr/local/bin/ispell")             ;; 设置为ispell,默认为：aspell
(setq spell-checking-enable-by-default
      nil)                                 ;; 关闭拼写检查
(add-hook 'dired-mode-hook 'diredful-mode)
(add-hook 'dired-mode-hook 'dired-icon-mode)
(when (version<= "26.1" emacs-version)     ;; emacs 26.1 开始这个值默认为t，还原之
  (setq term-char-mode-point-at-process-mark nil)
  (global-display-line-numbers-mode))

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
;; ubuntu linux:
;;     1. sudo cp TTF/*.ttf  /usr/share/fonts
;;     2. reboot computer or execute command: fc-cache -f -v
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

;; 下面配置好ace-jump-mode的回跳
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
(add-hook 'ace-jump-mode-before-jump-hook 'aborn/push-marker-stack)
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
;; (require 'column-marker)
;; (add-hook 'foo-mode-hook (lambda () (interactive) (column-marker-1 80)))
;; (global-set-key [?\C-x ?m] 'column-marker-3)
;; (require 'fill-column-indicator)
;; (setq fci-rule-width 2)
;; (setq fci-rule-color "yellow")
;; (setq fci-rule-column 80)
;; (define-globalized-minor-mode
;;  global-fci-mode fci-mode (lambda () (fci-mode 1)))
;; (global-fci-mode 1)

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

(global-disable-mouse-mode)
(setq wttrin-default-cities '("Shanghai"))
(defun ab/shell-command-to-string (command)
  (replace-regexp-in-string "\r?\n$" ""    ;; 去掉换行符号
                            (shell-command-to-string command)))

;; 当emacs退出时，执行这个函数
(defun aborn/exec-when-emacs-kill ()
  (message "exec some operationi when kill emacs")
  (aborn/save-message-content)
  (message "now emacs exit!"))

(add-hook 'after-init-hook
          (lambda ()
            (message "after-init-hook")))
(add-hook 'kill-emacs-hook 'aborn/exec-when-emacs-kill)

;; 设置neotree
(setq neo-toggle-window-keep-p t)       ;; 刷新时保持光标在当前位置
(setq neo-show-hidden-files nil)        ;; 不显示隐藏文件
(setq neo-force-change-root t)          ;; 当root改变时，是否强制相应改变而不需要询问
(setq neo-persist-show t)               ;; C-x 1 时neotree window不关闭
(setq split-window-preferred-function 'neotree-split-window-sensibly)
(require 'all-the-icons)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
;; (setq neo-theme (if window-system 'classic 'arrow))
;; (setq neo-theme 'icons)
(spacemacs/set-leader-keys "tr" 'neotree-refresh)
(add-hook 'neotree-mode-hook (lambda () (disable-mouse-mode -1)))

;; 下面是一些定时任务
(require 'aborn-timer-task)
(aborn/timer-task-each-8hour 'aborn/git-code-update)

;; 下面是deft的配置
(setq deft-extensions '("txt" "text" "md" "markdown" "org"))
(setq deft-directory "~/github/eden")
(setq deft-recursive t)
(global-set-key [f8] 'deft)

;; https://github.com/Fanael/highlight-defined
(add-hook 'emacs-lisp-mode-hook 'highlight-defined-mode)

;; wakatime的配置
;; 两个关键变量 wakatime-api-key & wakatime-cli-path (which wakatime)
;; https://wakatime.com/help/plugins/emacs
;; https://wakatime.com/@aborn
;; (global-wakatime-mode)
;; set as your wakatime-api-key

(if (and (local-config-check?)
         (local-config-get "wakatime-api-key"))
    (setq wakatime-api-key (local-config-get "wakatime-api-key"))
  (progn
    (if (boundp 'wakatime-api-key)
        (message "wakatime-api-key already bounded! its value is %s" wakatime-api-key)
      (message "warning: cannot find wakatime-api-key in %s." local-config-file))))

;; https://github.com/wakatime/wakatime-mode/issues/6
(when (string= system-type "gnu/linux")
  (message "gnu/linux system")
  (setq wakatime-python-bin "/usr/bin/python2"))

;; helm-github-stars 插件
;; M-x helm-github-stars
;; 更新本地缓存 M-x helm-github-stars-fetch
(setq helm-github-stars-username "aborn")

;; (ensure-package-installed 'tree-mode)                ;; reddit需要tree-mode
(slpp-load-path-and-pkgs
 '(("~/.spacemacs.d/hotkey" my-keys-minor-mode)      ;; 全局的key-binding放在这里
   ("~/.spacemacs.d/modules" reddit)))

;; 对elisp或org文件，保存之前进行indent
(add-hook 'before-save-hook
          #'(lambda ()
              (let ((fname (buffer-file-name)))
                (when (or (f-ext? fname "org")
                          (f-ext? fname "el")
                          (f-ext? fname "rb"))
                  (aborn/indent-regin)))))

;; 将频繁访问的书签放在最前面
(defadvice bookmark-jump (after bookmark-jump activate)
  (let ((latest (bookmark-get-bookmark bookmark)))
    (setq bookmark-alist (delq latest bookmark-alist))
    (add-to-list 'bookmark-alist latest)))

(my-keys-minor-mode 1)
(add-hook 'minibuffer-setup-hook #'my-keys-turn-off)
(add-hook 'after-load-functions 'my-keys-have-priority)
(setenv "LC_ALL" "en_US.UTF-8")
;;; docs
;; 注意：ivy创建文件M-ENTER
;; 看这里：https://www.reddit.com/r/emacs/comments/40u3ra/how_to_create_a_new_file_with_ivymode_on/

(aborn/log "aborn's emacs have successful finished initialization!")
(message "aborn's emacs have successful finished initialization!")
(message "------------------------------------------------------")
;; (revert-buffer-with-coding-system)   ;; Text模式下中文正常显示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; last update by Aborn Jiang (aborn@aborn.me) at 2017-04-22
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
