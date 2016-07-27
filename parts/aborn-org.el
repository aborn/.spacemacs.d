;; --------------------------------------------------------------------
;; setting org-mode
;; --------------------------------------------------------------------
;; (setq org-todo-keywords
;; '((sequence "TODO" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))
(setq org-todo-keywords
      '((sequence "TODO(t)" "ONGOING(o)" "|" "DONE(d)")))

(setq org-log-done 'time)   ;;  setting close time
;; (setq org-log-done 'note)   ;;  setting a log note
;; (set org-modules 'habits)
(setq org-startup-folded nil)  ;; 打开org文件默认不展开所有
(when (string= system-type "darwin")
  (setq org-directory "/Users/aborn/github/iGTD/mobile")
  (setq org-mobile-directory "/Users/aborn/github/iGTD/mobile")
  (setq org-mobile-inbox-for-pull "/Users/aborn/github/iGTD/from-mobile.org"))

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

(provide 'aborn-org)
