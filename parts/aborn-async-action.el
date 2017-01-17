;; some async actions, which will cost some time running in background.
(defvar aborn-git-project-list
  '("~/.emacs.d/" "popkit" "~/.spacemacs.d/" "piece-meal" "pelpa"
    "eden" "leanote-mode" "v2ex-mode" "learn-elisp-by-examples"
    "multi-term-plus" "eeb" "emacs-neotree" "nicemacs"
    "appkit-web" "emacs-cookbook" "emacsist" "diary"
    "dotfiles"))

(defun aborn/git-code-update ()
  "update code async."
  (interactive)
  (let* ((begin-time (current-time)))
    (async-start
     ;; 异步执行更新code操作
     `(lambda ()
        ,(async-inject-variables "\\`load-path\\'")
        ,(async-inject-variables "\\`aborn-git-project-list\\'")
        ,(async-inject-variables "\\`begin-time\\'")
        (require 'aborn-log)
        (require 'subr-x)
        (aborn/log "exec-when-emacs-boot....")
        (dolist (elt aborn-git-project-list)
          (let* ((working-directory
                  (if (or (string-prefix-p "/" elt) (string-prefix-p "~" elt))
                      elt
                    (concat "~/github/" elt "/")))
                 (default-directory working-directory))
            (unless (file-exists-p default-directory)
              (aborn/log (format "path %s doesnot exists" default-directory)))
            (when (file-exists-p default-directory)
              (aborn/log (shell-command-to-string "echo $PWD"))
              ;; 执行操作是异步的!
              (aborn/log (shell-command-to-string "git pull")))))
        (aborn/log "finished aborn/git-code-update.")
        begin-time)
     (lambda (result)
       (message "%s aborn/git-code-update finished. time cost: %ss"
                (aborn/log-format "")
                (float-time (time-subtract (current-time) result)))))))

(provide 'aborn-async-action)
