;;; aborn-char.el --- Aborn's char-releated actions.  -*- lexical-binding: t; -*-

;; Copyright (C) 2016 Aborn Jiang

;; Author: Aborn Jiang <aborn.jiang@gmail.com>
;; Version: 0.1.0
;; Keywords: char

;;; Code:

(require 'aborn-core)

(defcustom aborn-replace-pairs
  [
   ["." "。"]
   ["," "，"]
   [":" "："]
   [";" "；"]
   ["?" "？"]
   ["!" "！"]
   ]
  "replace pairs"
  :group 'aborn
  :type 'sexp)

;;;###autoload
(defun aborn/convert-en-punctuation-to-cn (args)
  "Convert English punctuation to chinese style or vice versa."
  (interactive "P")
  (if args
      (aborn/loop-each-char-action 'aborn/do-convert-action t)
    (aborn/loop-each-char-action 'aborn/do-convert-action))
  (if buffer-file-name
      (save-buffer)))

(defun aborn/loop-each-char-action (action &optional args)
  "Do loop `ACTION' iterator for each char in current buffer."
  (unless (functionp action)
    (error "Argument action needs function type."))
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (funcall action args)
      (forward-char))))

(defun aborn/is-A-to-Z (char)
  "char a(A) ~ z(Z), 0~9"
  (and
   (>= char 33)
   (<= char 126)))

(defun aborn/do-convert-action (&optional versa)
  "do convert action"
  (let* ((cchar (char-after))                   ;; char current
         (cachar (char-after (+ (point) 1)))    ;; char after
         (cbchar (char-before (point))))        ;; char before
    (mapc
     (lambda (x)
       (when (and
              (string= (aref x 0) (string cchar))
              (or versa
                  (or (not cbchar) (not (aborn/is-A-to-Z cbchar))))
              (or versa
                  (not (aborn/is-A-to-Z cachar))))
         (aborn/replace-current-char (aref x 1))))
     (if versa
         (mapcar (lambda (x) (vector (elt x 1) (elt x 0))) aborn-replace-pairs)
       aborn-replace-pairs))
    ))

(defun aborn/replace-current-char (char)
  "Replace current char with `CHAR'"
  (unless (or (characterp char)
              (stringp char))
    (error "Argument error, need char or string type."))
  (delete-char 1)
  (insert char))

(provide 'aborn-char)
;;; aborn-char.el ends here
