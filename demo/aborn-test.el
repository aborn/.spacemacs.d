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

(defun aborn/test-async-leanote ()
  "578e2182ab644133ed01800b"
  (interactive)
  (let* ((key "noteId"))
    (async-start
     (lambda ()
       (require 'package)
       (package-initialize)
       (add-to-list 'load-path "~/github/leanote-mode")
       (require 'leanote)
       (let* ((result nil)
              (id "578e2182ab644133ed01800b"))
         (setq result (leanote-get-note-and-content id))
         result))
     (lambda (result)
       (setq ab/debug result))))
  )

(defun aborn/test-async ()
  (interactive)
  (async-start
   ;; What to do in the child process
   (lambda ()
     (add-to-list 'load-path "~/.spacemacs.d/parts")
     (require 'aborn-log)
     (aborn/log "This is a test %s" aa)
     (sleep-for 3)
     222))
  ;; What to do when it finishes
  (lambda (result)
    (message "Async process done, result should be 222: %s" result)))

(defun aborn/test-async-fc (result)
  "finished call"
  (message "result=%s" result))

(defun async-start-process (name program finish-func &rest program-args)
  "Start the executable PROGRAM asynchronously.  See `async-start'.
PROGRAM is passed PROGRAM-ARGS, calling FINISH-FUNC with the
process object when done.  If FINISH-FUNC is nil, the future
object will return the process object when the program is
finished.  Set DEFAULT-DIRECTORY to change PROGRAM's current
working directory."
  (let* ((buf (generate-new-buffer (concat "*" name "*")))
         (proc (let ((process-connection-type nil))
                 (apply #'start-process name buf program program-args))))
    (with-current-buffer buf
      (set (make-local-variable 'async-callback) finish-func)
      (set-process-sentinel proc #'async-when-done)
      (unless (string= name "emacs")
        (set (make-local-variable 'async-callback-for-process) t))
      proc)))

;; 在子进程中插入参数
(defun aborn/test-async-param ()
  (interactive)
  (let* ((param "param-a"))
    (async-start
     `(lambda ()
        ,(async-inject-variables "\\`param\\'")
        (format "param = %s" param))
     'aborn/test-async-fc)))

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

(defun aborn/test-helm ()
  "test helm"
  (interactive)
  (let (collection)
    (setq collection '(("a key" "good") ("second" "secoe val") ("c" "ddd")))
    (helm :sources (helm-build-sync-source "test"
                     :candidates collection
                     :fuzzy-match t
                     :action (lambda (x)
                               (setq ab/debug x)
                               (message "sssddd %s" x)))
          :buffer "*helm test*"
          )))
