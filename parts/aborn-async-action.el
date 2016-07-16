;; some async actions, which will cost some time.
(defun aborn/git-code-update ()
  "update code async."
  (interactive)
  (async-start
   ;; 异步执行更新code操作
   (lambda ()
     (add-to-list 'load-path "~/.spacemacs.d/parts")
     (require 'aborn-log)
     (require 'subr-x)
     (aborn/log "exec-when-emacs-boot....")
     (let ((ab--git-project-list
            '("~/.emacs.d/" "popkit" "~/.spacemacs.d/" "piece-meal" "pelpa"
              "eden" "leanote-mode" "v2ex-mode")))
       (dolist (elt ab--git-project-list)
         (let* ((working-directory
                 (if (or (string-prefix-p "/" elt) (string-prefix-p "~" elt))
                     elt
                   (concat "~/github/" elt "/")))
                (default-directory working-directory))
           (aborn/log (shell-command-to-string "echo $PWD"))
           ;; 执行操作是异步的!
           (aborn/log (shell-command-to-string "git pull")))))
     (aborn/log "finished aborn/git-code-update."))
   (lambda (result)
     (message "finished aborn/git-code-update. %s" result))))

(provide 'aborn-async-action)
