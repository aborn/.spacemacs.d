;; --------------------------------------------------------------------
;; setting org-mode
;; --------------------------------------------------------------------
;; (setq org-todo-keywords
;; '((sequence "TODO" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))
(setq org-todo-keywords
	  '((sequence "TODO" "ONGOING" "DONE" "|" "CLOSED")))
(setq org-log-done 'time)   ;;  setting close time
(setq org-log-done 'note)   ;;  setting a log note
;; (set org-modules 'habits)
(setq org-startup-folded nil)  ;; 打开org文件默认不展开所有
(when (string= system-type "darwin")
  (setq org-directory "/Users/aborn/github/iGTD/mobile")
  (setq org-mobile-directory "/Users/aborn/github/iGTD/mobile")
  (setq org-mobile-inbox-for-pull "/Users/aborn/github/iGTD/from-mobile.org"))

(provide 'aborn-org)
