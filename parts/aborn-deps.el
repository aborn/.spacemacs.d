;;; aborn-deps.el --- Aborn's emacs deps releated package

;; Copyright (C) 2017 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.5") (exec-path-from-shell "1.11"))
;; This file is not part of GNU Emacs.

;;; Code:

(require 'exec-path-from-shell)

(defun aborn/deps-verify ()
  "Make sure all deps installed."
  (interactive)
  (aborn/deps-verify-lang-go))

(defun aborn/deps-verify-lang-go ()
  "Check language go deps."
  (let ((go-path (exec-path-from-shell-getenv "GOPATH")))
    (message "start check go-language deps.")
    (unless go-path
      (error "No go lanuage envs for $GOPATH."))
    (message "$GOPATH=%s" go-path)))

(provide 'aborn-deps)
;;; aborn-deps.el ends here
