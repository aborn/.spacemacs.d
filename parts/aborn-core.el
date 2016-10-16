;;; aborn-core.el --- Aborn's core package

;; Copyright (C) 2016 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; This file is not part of GNU Emacs.

;;; Code:

(defun aborn/add-to-load-path (dir)
  "Util function add path to load-path"
  (add-to-list 'load-path dir))

(defun aborn/load-path-pkgs (path pkgs &optional is-load-file)
  "Active `PATH' all `PKGS'"
  (let ((actived-pkgs '())
        (unknown-pkgs '()))
    (mapc #'(lambda (pkg)
              (let* ((pkg-str (if (symbolp pkg) (symbol-name pkg) pkg))
                     (file-name (expand-file-name (concat pkg-str ".el") path)))
                (unless (file-exists-p file-name)
                  (add-to-list 'unknown-pkgs pkg-str))
                (when (and (file-exists-p file-name)
                           (or (symbolp pkg) (stringp pkg)))
                  (if is-load-file
                      (load-file file-name)
                    (progn
                      (aborn/add-to-load-path path)
                      (require (intern pkg-str))  ;; 注意make-symbol与intern的关系
                      (add-to-list 'actived-pkgs pkg-str))))))
          pkgs)
    (message (aborn/log-format
              (format "load path %s active feautes:%s"
                      path
                      (mapconcat 'identity actived-pkgs " "))))
    (when unknown-pkgs
      (message "warning: not find [%s] package in path %s"
               (mapconcat 'identity unknown-pkgs " ")
               path))))

(defun aborn/load-path-and-pkgs (args &optional is-load-file)
  "Add path to load-path and require package.
   Usage: (aborn/load-path-and-require '((path1 pkg11 pkg12) (path2 pkg2)))"
  (mapc #'(lambda (x)
            (let* ((path (car x))
                   (pkgs (cdr x)))
              (unless (file-exists-p path)
                (message "warning: path %s doesn't exists!!"))
              (when (and path pkgs
                         (file-exists-p path)
                         (file-readable-p path))
                (aborn/load-path-pkgs path pkgs is-load-file))))
        args))
