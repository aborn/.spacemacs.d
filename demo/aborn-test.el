(defun aborn/test-start-process ()
  "test aysnc proecess"
  (interactive)
  (start-process "test-start-process" "*tsp*" "ls"
                 "-l" (file-truename "~/.spacemacs.d")))

(fset 'return-a-marked-pos
      (lambda (&optional arg)
        "Keyboard macro."
        (interactive "p")
        (kmacro-exec-ring-item
         (quote ([21 134217848 115 101 116 45 109 97 114 107 45 99 111 109 109 97 110 100 return] 0 "%d")) arg)))

(require 'widget-demo)
(require 'cip-mode)

(defun aborn/test-timer-task-async ()
  (async-start
   (lambda ()
     (sleep-for 10)
     (setq ab/debug '("a" "bbb"))
     (message "async")))
  )

(defun aborn/test-timer-task ()
  "runing func"
  (message (format-time-string "[%Y-%m-%d %H:%M:%S] " (current-time)))
  (sleep-for 5)
  (setq ab/debug '("a" "b")))

(defun aborn/test-timer ()
  "test timer task"
  (interactive)
  (setq ab/debug2 (run-with-timer 5 nil 'aborn/test-timer-task-async)))

(defun aborn/test-cl-loop (arr)
  ""
  (cl-loop for elt in (append arr nil)
           collect
           (let ((a ""))
             (message "%s" elt)
             ))
  )

(defun aborn/test-interactive (msg)
  "test interactive msg"
  (interactive "sCommit Message: ")
  (message "#you input %s ## lenght=%d" msg (length msg)))

(defun aborn/test-prefix (new-name)
  "test prefix"
  (interactive "sNew name: ")
  (let* ((filename (buffer-file-name))
         (ext (file-name-extension filename)))
    (message "filename:%s, ext:%s" filename ext)
    (when (equal current-prefix-arg '(4))
      (message "insert new name %s only" new-name)))
  )

(defun my-git-timemachine-show-selected-revision ()
  "Show last (current) revision of file."
  (interactive)
  (let (collection)
    (setq collection
          (mapcar (lambda (rev)
                    ;; re-shape list for the ivy-read
                    (cons (concat (substring (nth 0 rev) 0 7) "|" (nth 5 rev) "|" (nth 6 rev)) rev))
                  (git-timemachine--revisions)))
    (setq ab/debug collection)
    (ivy-read "commits:"
              collection
              :action (lambda (rev)
                        (git-timemachine-show-revision rev)))))

(defun my-git-timemachine ()
  "Open git snapshot with the selected version.  Based on ivy-mode."
  (interactive)
  (unless (featurep 'git-timemachine)
    (require 'git-timemachine))
  (git-timemachine--start #'my-git-timemachine-show-selected-revision))

(defun aborn/test-ml ()
  ""
  (mapcar (lambda (elt)
            (let ((type (car elt))
                  (main-val nil))
              (if (eq type 'main)
                  (progn
                    (setq main-val (cdr elt))
                    (add-to-list 'main-val '(leanote-status :when active) t)
                    (cons 'main main-val)
                    )
                elt)
              ))
          spaceline--mode-lines))
