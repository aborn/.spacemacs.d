
(defvar ab/debug-helm-file "~/.emacs.d/debugonly")
(defvar ab/debug-helm nil)

(when (file-readable-p ab/debug-helm-file)
  (load-file ab/debug-helm-file))

(debug-on-entry 'helm-adaptive-sort)
(debug-on-entry 'helm-adapt-use-adaptive-p)

(debug-on-entry 'helm-adaptive-save-history)

(debug-on-entry 'helm-adaptive-maybe-load-history)


(defun ab/demo-fun (arg)
  (message (format "arg=%s" arg)))

(defun ab/debug-demo ()
  (interactive)
  (ab/demo-fun "good"))

(defun ab/debug-json ()
  (interactive)
  (message (json-encode '(:a "b"))))

(defun ab/ivy-read-example ()
  "Elisp completion at point."
  (interactive)
  (let* ((bnd (bounds-of-thing-at-point 'symbol))
         (str (buffer-substring-no-properties (car bnd) (cdr bnd)))
         (candidates (all-completions str obarray))
         (ivy-height 7)
         (res (ivy-read (format "pattern (%s): " str)
                        candidates)))
    (when (stringp res)
      (delete-region (car bnd) (cdr bnd))
      (insert res))))

(defun ab/get-ivy-test-list (key)
  ""
  (interactive)
  (if (string-equal key "ab")
      (list '("fff" "ggg" "hhh"))
    (list '("kkk" "mmm"))))

(defun ab/ivy-read-test ()
  ""
  (interactive)
  (ivy-read (format "input key:")
            (ab/get-ivy-test-list )))

(defun counsel-package-install ()
  (interactive)
  (ivy-read "Install package: "
            (delq nil
                  (mapcar (lambda (elt)
                            (unless (package-installed-p (car elt))
                              (symbol-name (car elt))))
                          package-archive-contents))
            :action (lambda (x)
                      (package-install (intern x)))
            :caller 'counsel-package-install))

;; (global-set-key (kbd "M-p") 'display-prefix)
(defun display-prefix (arg)
  "Display the value of the raw prefix arg."
  (interactive "P")
  (if (equal current-prefix-arg '(4))
      (message "ggg")
    (message "kkk"))
  (message "%s%s" arg current-prefix-arg))

(defun test-fun ()
  "Prompt user to enter a file path, with file name completion and input history support."
  (interactive)
  (let ((input-value  (read-from-minibuffer
                       (format "Directory (default %s):" default-directory) default-directory )))
    (message "Input value is 「%s」." input-value)))

(setq neo-hidden-regexp-list '("^\\." "\\.pyc$" "~$" "^#.*#$" "\\.elc$" ".el$"))

;; following only can apply in emacs 26
(defmacro define-background-function-wrapper (bg-function fn)
  (let ((is-loading-sym (intern (concat "*"
                                        (symbol-name bg-function)
                                        "-is-loading*"))))
    `(progn
       (defvar ,is-loading-sym nil)
       (defun ,bg-function ()
         (interactive)
         (when ,is-loading-sym
           (message ,(concat (symbol-name fn) " is already loading")))
         (setq ,is-loading-sym t)
         (make-thread (lambda ()
                        (unwind-protect
                            (,fn)
                          (setq ,is-loading-sym nil))))))))

(defun threadaction ()
  "Emacs multi-thread example runner."
  (message (aborn/log-format "begin running..."))
  (sleep-for 1)
  (message (aborn/log-format "running at point 1"))
  (sleep-for 5)
  (message (aborn/log-format "running at point 6"))
  (sleep-for 10)
  (message (aborn/log-format "running at point 16"))
  (sleep-for 15)
  (message (aborn/log-format "finished bg-runner.")))

(define-background-function-wrapper bg-threadaction threadaction)

(defun async-threadaction ()
  "Emacs async example runner."
  (interactive)
  (async-start            
   ;; 异步执行更新code操作
   `(lambda ()
      ,(async-inject-variables "\\`load-path\\'")
      (require 'aborn-log)
      (message (aborn/log-format "begin running..."))
      (sleep-for 1)
      (message (aborn/log-format "running at point 1"))
      (sleep-for 5)
      (message (aborn/log-format "running at point 6"))
      (sleep-for 10)
      (message (aborn/log-format "running at point 16"))
      (sleep-for 15)
      (message (aborn/log-format "finished bg-runner."))
      )
   (lambda (result)
     (message "finished"))))

(if (version<= emacs-version "26.0.50")
    (message "make-thread need emacs 26+, current emacs version %s"
             emacs-version)
  (make-thread (lambda ()
                 (message "running in bg."))))

(make-thread (lambda ()
               (sleep-for 10)     ;; sleep-for  site-for
               (with-current-buffer "z"
                 (insert "foo"))))

(defun aborn/show-major-mode ()
  "Show current major mode."
  (interactive)
  (message "%s" major-mode))

(defun load-path-file-exists-p (fname)
  (let* ((res nil))
    (mapcar (lambda (elt)
              (when (file-exists-p (expand-file-name fname elt))
                (setq res t)))
            load-path)
    res))
