;;; aborn-utils.el --- Aborn's utils package.  -*- lexical-binding: t; -*-
;; Copyright (C) 2016 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((let-alist "1.0.3") (s "1.10.0"))
;; Keywords: utils

(defun aborn/create-scratch-buffer nil
  "create a scratch buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun aborn/just-one-space-debug ()
  "Only for debug"
  (interactive)
  (message "count %d" (aborn/cal-space-count)))

(defun aborn/cal-space-count ()
  "Count how many space char."
  (let ((char-list (list (char-after)
                         (char-before))))
    (when (aborn/is-space (char-after))
      (push (char-after (+ 1 (point))) char-list))
    (when (aborn/is-space (char-before))
      (push (char-before (- (point) 1)) char-list))
    (reduce '+
            (mapcar
             #'(lambda (x)
                 (if (aborn/is-space x)
                     1
                   0))
             char-list))
    ))

(defun aborn/is-space (char)
  (or (eq ?\b char)   ;; 8 backspace, BS, C-h
      (eq ?\t char)   ;; 9 tab, TAB, C-i
      (eq ?\n char)   ;; 10 newline, C-j
      (eq ?\v char)   ;; 11 vertical tab, C-k
      (eq ?\s char)   ;; 32 space character, SPC
      ))

(defun aborn/just-one-space (&optional n)
  "Intelligent version of just-one-space."
  (interactive "*p")
  (if (or (> (aborn/cal-space-count) 1)
          (= (aborn/cal-space-count) 0))
      (just-one-space)
    (just-one-space 0)))

(defun aborn/get-ip (arg)
  "Get current machine local ip adress."
  (interactive "P")
  (insert (shell-command-to-string "ifconfig |egrep \"10\\.|172\\.|192\\.\" |awk '{print $2}'")))

(defun aborn/copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (or
                       (eq major-mode 'dired-mode)
                       (eq major-mode 'inferior-emacs-lisp-mode)
                       (eq major-mode 'term-mode))
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "File name was copied '%s' to the clipboard." filename))))

;; http://stackoverflow.com/questions/28221079/ctrl-backspace-in-emacs-deletes-too-much/39438119#39438119
(defun aborn/backward-kill-word ()
  "Customize/Smart backward-kill-word."
  (interactive)
  (let* ((cp (point))
         (end))
    (save-excursion
      (let* ((pos (search-backward-regexp "\n")))
        (setq end (and (s-blank? (s-trim (buffer-substring pos cp)))
                       pos))))
    (if end
        (kill-region cp end)
      (backward-kill-word 1))))

(defun aborn/elisp-function-find ()
  "Find current elisp file function!"
  (interactive)
  (let* (collection key)
    (setq collection (aborn/current-elisp-functions))
    (setq ab/debug collection)
    (setq key (completing-read "find elisp function by name: "
                               collection))
    (let ((pos-line (car (assoc-default key collection))))
      (message "pos-line=%s" pos-line)
      )))

(defun aborn/current-elisp-functions ()
  "Get current elisp function defs"
  (let (result)
    (save-excursion
      (beginning-of-buffer)
      (while (and (not (eobp))
                  (string-match "(defun\s+" (buffer-substring (point) (point-max))))
        (let ((ft (re-search-forward "(defun\s+"))
              (fe (re-search-forward "\s")))
          (when (and ft fe)
            (message "%s  %s" (line-number-at-pos) (buffer-substring ft fe))
            (add-to-list 'result `(,(format "%s %s" (line-number-at-pos) (s-trim (buffer-substring-no-properties ft fe)))
                                   .
                                   ,(line-number-at-pos)
                                   )))
          )))
    result))

(provide 'aborn-utils)
;;; aborn-utils.el ends here
