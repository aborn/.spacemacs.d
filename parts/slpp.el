;;; slpp.el --- Smart load path and packages. -*- lexical-binding: t; -*-

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "24.4") (s "1.10.0"))
;; Keywords: convenience load path packages
;; Homepage: https://github.com/aborn/.spacemacs.d
;; URL: https://github.com/aborn/.spacemacs.d

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Smart util function to load path and packages.
;;

;;; Code:

(defgroup slpp nil
  "aborn package group"
  :prefix "slpp-"
  :group 'convenience)

(defun slpp-add-to-load-path (dir)
  "Util function add path to load-path"
  (add-to-list 'load-path dir))

(defun slpp-log-format (origin)
  "Format `ORIGIN' log with timestamp."
  (concat (format-time-string "[%Y-%m-%d %H:%M:%S] " (current-time)) origin))

(defun slpp-load-path-pkgs (path pkgs &optional is-load-file)
  "Active `PATH' all `PKGS'."
  (let ((actived-pkgs '())
        (unknown-pkgs '()))
    (mapc #'(lambda (pkg)
              (let* ((pkg-obj (if (listp pkg) (car pkg) pkg))
                     (before-action (if (listp pkg) (plist-get (cdr pkg) :before)))
                     (after-action (if (listp pkg) (plist-get (cdr pkg) :after)))
                     (pkg-str (if (symbolp pkg-obj) (symbol-name pkg-obj) pkg-obj))
                     (file-name (expand-file-name (concat pkg-str ".el") path)))
                (unless (file-exists-p file-name)
                  (add-to-list 'unknown-pkgs pkg-str))
                (when (and (file-exists-p file-name)
                           (or (symbolp pkg-obj) (stringp pkg-obj)))
                  (if is-load-file
                      (load-file file-name)
                    (progn
                      (slpp-add-to-load-path path)
                      (and (functionp before-action)
                           (funcall before-action))
                      (require (intern pkg-str))  ;; 注意make-symbol与intern的关系
                      (and (functionp after-action)
                           (funcall after-action))
                      (add-to-list 'actived-pkgs pkg-str))))))
          pkgs)
    (message (slpp-log-format
              (format "load path %s active feautes:%s"
                      path
                      (mapconcat 'identity actived-pkgs " "))))
    (when unknown-pkgs
      (message "warning: not find [%s] package in path %s"
               (mapconcat 'identity unknown-pkgs " ")
               path))))

(defun slpp-load-path-and-pkgs (args &optional is-load-file)
  "Add path to load-path and require package.
   Usage: (slpp-load-path-and-require '((path1 pkg11 pkg12) (path2 pkg2)))"
  (mapc #'(lambda (x)
            (let* ((path (car x))
                   (pkgs (cdr x)))
              (unless (file-exists-p path)
                (message "warning: path %s doesn't exists!!" path))
              (when (and path pkgs
                         (file-exists-p path)
                         (file-readable-p path))
                (slpp-load-path-pkgs path pkgs is-load-file))))
        args))

(provide 'slpp)
;;; slpp.el ends here
