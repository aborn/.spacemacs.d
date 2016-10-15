;;; aborn-core.el --- Aborn's core package

;; Copyright (C) 2016 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((let-alist "1.0.3") (s "1.10.0"))
;; Keywords: core function

;; This file is not part of GNU Emacs.

;;; Code:

(defun aborn/add-to-load-path (dir)
  "Util function add path to load-path"
  (add-to-list 'load-path dir))

(defun aborn/load-path-pkgs (path pkgs &optional is-load-file)
  (setq ab/debug pkgs)
  (mapc #'(lambda (pkg)
            (let ((file-name (expand-file-name (concat (if (symbolp pkg)
                                                           (symbol-name pkg)
                                                         pkg)
                                                       ".el")
                                               path)))
              (when (and (file-exists-p file-name)
                         (or (symbolp pkg) (stringp pkg)))
                (if is-load-file
                    (load-file file-name)
                  (progn
                    (aborn/add-to-load-path path)
                    (require (if (stringp pkg)
                                 (make-symbol pkg)
                               pkg)))))))
        pkgs))

(defun aborn/load-path-and-pkgs (args &optional is-load-file)
  "Add path to load-path and require package.
   Usage: (aborn/load-path-and-require '((path1 pkg11 pkg12) (path2 pkg2)))"
  (mapc #'(lambda (x)
            (let* ((path (car x))
                   (pkgs (cdr x)))
              (when (and path pkgs
                         (file-exists-p path)
                         (file-readable-p path))
                (aborn/load-path-pkgs path pkgs is-load-file)
                (message "path:%s finished." path))))
        args))
