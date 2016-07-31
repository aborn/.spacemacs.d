(defun aborn/test-start-process ()
  "test aysnc proecess"
  (interactive)
  (start-process "test-start-process" "*tsp*" "ls"
                 "-l" (file-truename "~/.spacemacs.d")))

(async-start
 ;; What to do in the child process
 (lambda ()
   (message "This is a test")
   (sleep-for 3)
   222)
 ;; What to do when it finishes
 (lambda (result)
   (message "Async process done, result should be 222: %s" result)))

(fset 'return-a-marked-pos
      (lambda (&optional arg)
        "Keyboard macro."
        (interactive "p")
        (kmacro-exec-ring-item
         (quote ([21 134217848 115 101 116 45 109 97 114 107 45 99 111 109 109 97 110 100 return] 0 "%d")) arg)))

(require 'widget-demo)
(require 'cip-mode)

(defun aborn/test-async ()
  (interactive)
  (async-start
   ;; What to do in the child process
   (lambda ()
     (add-to-list 'load-path "~/.spacemacs.d/parts")
     (require 'aborn-log)
     (aborn/log "This is a test")
     (sleep-for 3)
     222)
   ;; What to do when it finishes
   (lambda (result)
     (message "Async process done, result should be 222: %s" result))))

(require 'timp)
(defun aborn/test-timp ()
  "test timp multi-thread, actual its multi-process"
  (interactive)
  (let ((thread1 (timp-get :name "thread1" :persist t)))
    (when (timp-validate thread1)
      (message "thread1: alive")
      ;; 这个require-package的机制比较好，不需要处理load-path
      (timp-require-package thread1 'aborn-log)  
      (timp-send-exec thread1 (lambda ()
                                (aborn/log "begin to run thread1.")
                                (message "start thread1 job...")
                                (sleep-for 10)
                                (message "after 10s")
                                (sleep-for 50)
                                (message "after 50s")
                                (sleep-for 120)
                                (message "after 120s")
                                (mapcar 'number-to-string (number-sequence 1 99)))
                      :reply-func (lambda (result)
                                    (aborn/log "finished thread1, now callback!")
                                    (message "finished thread1 job. now callback!")
                                    (message (car (last result)))))
      (timp-quit thread1))))

;; 函数可选参数
(defun aborn/test-fun-parameter (a &optional b &rest args)
  (interactive)
  (when (null b)
    (message "paramete b is not provided, use default.")
    (setq b "ddd"))    ;; set to default value
  (message "a=%s, b=%s, rest-args-length:%d" a b (length args)))

(setq ab/debug '("a" "b" "d" "m" "eee"))

(defun aborn/test-timer-test ()
  "test"
  (message (format-time-string "[%Y-%m-%d %H:%M:%S] " (current-time))))

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
