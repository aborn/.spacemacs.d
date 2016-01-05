;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; multi-term emacs terminal config
;; emacs terminal 终端配置，在multi-term.el的基础上进行了优化
;;   注：multi-term 采用的是 term-mode 这种模式有两种子模式
;;     一种是 (term-char-mode) 像普通的shell
;;     另一种是 (term-line-mode) 像普通的buffer
;; 见： http://www.gnu.org/software/emacs/manual/html_node/emacs/Term-Mode.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'multi-term-config)
(require 'multi-term)

;; 一些基本配置
(setq multi-term-program "/bin/zsh")   ;; 设置shell
(setq multi-term-buffer-name "mterm")  ;; 设置buffer名字ls
(add-to-list 'term-bind-key-alist '("C-j"))
(add-to-list 'term-bind-key-alist '("C-o"))
(add-to-list 'term-bind-key-alist '("C-e"))
;;(add-to-list 'term-bind-key-alist '("M-f"))
;;(add-to-list 'term-bind-key-alist '("M-b"))
(add-to-list 'term-bind-key-alist '("C-k"))
(add-to-list 'term-bind-key-alist '("M-n"))  ;; 这句不起作用

(defun ab/is-at-end-line ()
  "判断是否在最后一行"
  (equal (line-number-at-pos) (count-lines (point-min) (point-max))))

(defun ab/is-term-mode ()
  "判断是否为 term 模式"
  (string= major-mode "term-mode"))

(defun ab/debug ()
  "debug时用"
  (interactive)
  (if (equal (display-pixel-width) 1920)
      (message "屏幕宽度为%s" (display-pixel-width))
    (message "操作系统为%s. %d" system-type (display-pixel-width))))

(defun last-term-buffer (l)
  "Return most recently used term buffer."
  (when l
    (if (eq 'term-mode (with-current-buffer (car l) major-mode))
        (car l) (last-term-buffer (cdr l)))))

;; 获得multi-term
(defun get-term ()
  "Switch to the term buffer last used, or create a new one if
    none exists, or if the current buffer is already a term."
  (interactive)
  (select-window (ab/get-window-at-right-botton))   ;; 先切换到右边的窗口
  (let ((b (last-term-buffer (buffer-list))))
    (if (or (not b) (eq 'term-mode major-mode))
        (progn (multi-term)
               (message "create a new multi-term!"))
      (progn (switch-to-buffer b)
             (message "switch a exist multi-term!"))))
  (define-key term-raw-map (kbd "M-n") 'ace-jump-mode))

;; 只后当是term-mode并且是最后一行时才采用 (term-send-left)
(defun ab/backward-char ()
  "Custom "
  (interactive)
  (if (not (ab/is-term-mode))
      (backward-char)
    (progn (if (not (ab/is-at-end-line))
               (backward-char)
             (progn (term-send-left)
                    (message "term-send-left"))))))

;; 只后当是term-mode并且是最后一行时才采用 (term-send-left)
(defun ab/forward-char ()
  "Custom "
  (interactive)
  (if (not (ab/is-term-mode))
      (forward-char)
    (progn (if (not (ab/is-at-end-line))
               (forward-char)
             (progn (term-send-right)
                    (message "term-send-right"))))))

;; 当处于最后一行时 "C-a" 将光标移动到 terminal开始处而不是这个行的头
(defun ab/move-beginning-of-line ()
  "move begin"
  (interactive)
  (if (not (ab/is-term-mode))
      (beginning-of-line)
    (if (not (ab/is-at-end-line))
        (beginning-of-line)
      (term-send-raw))))

;; 这样只能将 M-k 绑定到C-k的快捷键？？
(defun ab/kill-line ()
  "Search history reverse."
  (interactive)
  (term-send-raw-string "\C-k"))

(defun ab/delete-char ()
  "delete char"
  (interactive)
  (if (ab/is-at-end-line)
      (term-send-raw)
    (delete-char 1)))

;; 像intellij那样快速选择
;; (defun ab/extend-selection ()
;;   (interactive)
;;   (if (not (ab/is-term-mode))
;;       (extend-selection)
;;     (progn (if (ab/is-at-end-line)
;;                (term-send-raw)
;;              (extend-selection)))))


(defun ab/extend-selection ()
  (interactive)
  (term-send-raw-string "\C-l"))

;; Use Emacs terminfo, not system terminfo, mac系统出现了4m
(setq system-uses-terminfo nil)

;; 下面设置一些快捷键
(add-hook 'term-mode-hook
          (lambda ()
            ;; 下面设置multi-term buffer的长度无限
            (setq term-buffer-maximum-size 0)
            (add-to-list 'term-bind-key-alist '("M-[" . multi-term-prev))
            (add-to-list 'term-bind-key-alist '("M-]" . multi-term-next))
            (add-to-list 'term-bind-key-alist '("C-a" . ab/move-beginning-of-line))
            (add-to-list 'term-bind-key-alist '("M-k" . ab/kill-line))
            (add-to-list 'term-bind-key-alist '("C-d" . ab/delete-char))
            (add-to-list 'term-bind-key-alist '("C-b" . ab/backward-char))
            (add-to-list 'term-bind-key-alist '("C-f" . ab/forward-char))
            (add-to-list 'term-bind-key-alist '("M-l" . ab/extend-selection)) ;; error
            (setq show-trailing-whitespace nil)))

;; 初始化启动的时候打开一个terminal
(get-term)
