(defun test-butle (arg)
  "only used for ws-butler-global-mode test"
  (interactive "p")
  (message "turn off ws-butler-global-mode")
  (ws-butler-global-mode -1))


(zzz-to-char .
             [(20160122 440)
              ((emacs (24 4)) (cl-lib (0 5)) (avy (0 3 0)))
              "Fancy version of `zap-to-char' command"
              single
              ((:url . "https://github.com/mrkkrp/zzz-to-char") (:keywords "convenience"))
              ])


(defun ab/copy-to-clipboard (arg)
  "copy string content to clipboard"
  (interactive "P")
  (let* ((pkg-string-content (format-time-string "%Y-%m-%d.%H.%M" (current-time))))
    (kill-new pkg-string-content)))

(defun ab/test-start-process ()
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

(defun ab/test-async ()
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
(defun ab/test-timp ()
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

(add-to-list 'load-path "~/github/leanote-mode/")
(load "leanote")


(defun piece-meal/fun-option-parameter (a &optional b)
  (interactive)
  (when (null b)
    (message "paramete b is not provided")
    (setq b "ddd"))    ;; set to default value
  (message "a=%s, b=%s" a b))

(setq ab/debug '("a" "b" "d" "m"))

(defun aborn/timer-test ()
  "test"
  (message (format-time-string "[%Y-%m-%d %H:%M:%S] " (current-time))))
