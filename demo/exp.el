
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

(defun aborn/convert-en-punctuation-to-cn ()
  "Convert English punctuation to chinese style or vice versa."
  (interactive)
  (aborn/loop-each-char-action 'aborn/do-convert-action))

(defun aborn/loop-each-char-action (action)
  "Do loop `ACTION' iterator for each char in current buffer."
  (unless (functionp action)
    (error "Argument action needs function type."))
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (funcall action)
      (forward-char))))

(defun aborn/do-convert-action (&optional versa)
  "do convert action"
  (let ((cchar (char-after)))
    (when (char-equal ?中 cchar)
      (aborn/replace-current-char ?.)
      )))

(defun aborn/replace-current-char (char)
  "Replace current char with `CHAR'"
  (unless (or (characterp char)
              (stringp char))
    (error "Argument error, need char or string type."))
  (delete-char 1)
  (insert char))
