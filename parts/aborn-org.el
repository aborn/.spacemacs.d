;; --------------------------------------------------------------------
;; org-mode 相关配置及GTD
;; --------------------------------------------------------------------
;; (setq org-todo-keywords
;; '((sequence "TODO" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))
;; (setq org-todo-keywords
;;       '((sequence "TODO(t)" "ONGOING(o)" "|" "DONE(d)")))

(setq org-todo-keywords
      (quote ((sequence "TODO(t!)" "ONGOING(o!)" "|" "DONE(d!)")
              (sequence "REPORT(r!)" "BUG" "KNOWNCAUSE" "|" "FIXED(f!)")
              (sequence "PAUSED" "BLOCKED" "REVIEW" "|" "CANCELLED(c@)"))))

(setq org-log-done 'time)      ;;  setting close time
;; (setq org-log-done 'note)   ;;  setting a log note
;; (set org-modules 'habits)
(setq org-startup-folded nil)  ;; 打开org文件默认不展开所有

(when (string= system-type "darwin")
  (setq org-directory "~/github/eden/gtd/")  ;; 设置gtd的根目录
  (setq org-default-notes-file "inbox.org")  ;; 设置默认的记录文件
  (setq org-mobile-directory "/Users/aborn/github/iGTD/mobile")
  (setq org-mobile-inbox-for-pull "/Users/aborn/github/iGTD/from-mobile.org"))

;; 设置capture的模版
(setq org-capture-templates
      '(
        ("a" "Account" table-line
         (file+headline "~/github/eden/pass/pass.org" "Web accounts")
         "| %? | | %a | %U |")
        ("t" "Todo" entry (file+headline (expand-file-name org-default-notes-file org-directory) "Tasks")
         "* TODO %?\n  创建于:%T  %i\n  %a")
        ("l" "学习/了解" entry (file+headline (expand-file-name org-default-notes-file org-directory) "Need-To-Learn")
         "* %?\n  创建于:%T  %i\n  %a")
        ("b" "备忘" entry (file+headline (expand-file-name org-default-notes-file org-directory) "BackUps")
         "* %?\n  创建于:%T\n")
        ("c" "Calendar" entry (file+headline (expand-file-name org-default-notes-file org-directory) "Calendar")
         "* %?\n  创建于:%T\n")
        ("p" "Projects" entry (file+headline (expand-file-name org-default-notes-file org-directory) "Projects")
         "* %?\n  创建于:%T\n")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("o" "Others" entry (file+headline (expand-file-name org-default-notes-file org-directory) "Others")
         "* %?\n  %i\n  %a")))

(setq aborn-gtd-files (list (expand-file-name "finished.org" org-directory)
                            (expand-file-name "trash.org" org-directory)
                            (expand-file-name org-default-notes-file org-directory)
                            ))

(setq org-refile-targets
      '((nil :maxlevel . 3)       ;; 当前文件的最大层级
        (aborn-gtd-files :maxlevel . 3)))

(defun org-agenda-timeline-all (&optional arg)
  (interactive "P")
  (with-temp-buffer
    (dolist (org-agenda-file org-agenda-files)
      (insert-file-contents org-agenda-file nil)
      (end-of-buffer)
      (newline))
    (write-file "/tmp/timeline.org")
    (org-agenda arg "L")))
(define-key org-mode-map (kbd "C-c t") 'org-agenda-timeline-all)

(defface org-progress ; font-lock-warning-face
  (org-compatible-face nil
    '((((class color) (min-colors 16) (background light)) (:foreground "#A197BF" :bold t :background "#E8E6EF" :box (:line-width 1 :color "#A197BF")))
      (((class color) (min-colors 8)  (background light)) (:foreground "blue"  :bold t))
      (t (:inverse-video t :bold t))))
  "Face for PROGRESS keywords."
  :group 'org-faces)
(defface org-paused ; font-lock-warning-face
  (org-compatible-face nil
    '((((class color) (min-colors 16) (background light)) (:foreground "#D6CCF4" :bold t :background "#ECE9F5" :box (:line-width 1 :color "#D6CCF4")))
      (((class color) (min-colors 8)  (background light)) (:foreground "cyan"  :bold t))
      (t (:inverse-video t :bold t))))
  "Face for PAUSED keywords."
  :group 'org-faces)
(defface org-cancelled ; font-lock-warning-face
  (org-compatible-face nil
    '((((class color) (min-colors 16) (background light)) (:foreground "#3D3D3D" :bold t :background "#7A7A7A" :box (:line-width 1 :color "#3D3D3D")))
      (((class color) (min-colors 8)  (background light)) (:foreground "black"  :bold t))
      (t (:inverse-video t :bold t))))
  "Face for PROGRESS keywords."
  :group 'org-faces)
(defface org-review ; font-lock-warning-face
  (org-compatible-face nil
    '((((class color) (min-colors 16) (background light)) (:foreground "#FC9B17" :bold t :background "#FEF2C2" :box (:line-width 1 :color "#FC9B17")))
      (((class color) (min-colors 8)  (background light)) (:foreground "yellow"  :bold t))
      (t (:inverse-video t :bold t))))
  "Face for PROGRESS keywords."
  :group 'org-faces)
(defface org-blocked ; font-lock-warning-face
  (org-compatible-face nil
    '((((class color) (min-colors 16) (background light)) (:foreground "#FF8A80" :bold t :background "#ffdad6" :box (:line-width 1 :color "#FF8A80")))
      (((class color) (min-colors 8)  (background light)) (:foreground "red"  :bold t))
      (t (:inverse-video t :bold t))))
  "Face for PROGRESS keywords."
  :group 'org-faces)

(setq org-todo-keyword-faces
      (quote (("TODO" . org-todo)
              ("ONGOING" . org-progress)
              ("PAUSED" . org-paused)
              ("BLOCKED" . org-blocked)
              ("REVIEW" . org-review)
              ("DONE" . org-done)
              ("ARCHIVED" . org-done)
              ("CANCELLED" . org-cancelled)
              ("REPORT" . org-todo)
              ("BUG" . org-blocked)
              ("KNOWNCAUSE" . org-review)
              ("FIXED" . org-done))))

;; 如果所有的子任务完成了，那标识父任务也完成
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to ONGOING otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "ONGOING"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(setq
 org-completion-use-ido t         ;; use IDO for completion
 org-cycle-separator-lines 0      ;; Don't show blank lines
 org-catch-invisible-edits 'error ;; don't edit invisible text
 org-refile-targets '((org-agenda-files . (:maxlevel . 6)))
 )

;; 采用xelatex，支持Unicode(UTF-8)，支持中文汉字，注意：电脑里需要SimSun(宋体)这个字体
;; #+LATEX_HEADER: \setCJKmainfont{SimSun}   ;; 默认
;; #+LATEX_HEADER: \setCJKmainfont{Microsoft YaHei}
;; 原始值为: ("pdflatex -interaction nonstopmode -output-directory %o %f" "pdflatex -interaction nonstopmode -output-directory %o %f" "pdflatex -interaction nonstopmode -output-directory %o %f")
(setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
                              "xelatex -interaction nonstopmode %f"))
(provide 'aborn-org)
