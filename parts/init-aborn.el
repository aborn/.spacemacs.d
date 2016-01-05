(spacemacs/toggle-maximize-frame)      ;; 初始化后，最大化窗口
(when (string= system-type "darwin")  ;; mac系统用command代替alter作为键
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta))
(global-set-key "\C-o" 'other-window)
(global-set-key (kbd "C-j") 'helm-buffers-list)
(global-set-key (kbd "M-j") 'helm-find-files)

(require 'move-swift)
(require 'basic-key-binding)           ;; 基本的快捷键设置
(require 'major-mode-binding)          ;; local major mode key binding

(provide 'init-aborn)
